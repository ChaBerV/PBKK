import { useEffect, useState } from "react";

interface Post {
  id: string;
  posterName: string;
  content: string;
  replyToId?: string;
  createdAt: string;
  updatedAt: string;
  replies: Post[];
}

export default function Home() {
  const [posts, setPosts] = useState<Post[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [selectedPost, setSelectedPost] = useState<string | null>(null);
  const [alert, setAlert] = useState<{ type: string; message: string; } | null>(null)
  const [Modalclass, setModalclass] = useState<any>(null);
  const apiURL = process.env.NEXT_PUBLIC_API_URL

  async function loadPosts() {
    setLoading(true);
    try{
      const res = await fetch(`${apiURL}/posts`,{
        method: 'GET',
      });
      const parsedRes = await res.json();

      setPosts(parsedRes);
    }catch(error: any){
      setAlert({ type:`danger`, message:`Error: ${error.message} `});
    }
    setError(null);
    setLoading(false);
  }

  useEffect(() => {
    import("bootstrap").then((bs) => {
      setModalclass(() => bs.Modal);
    });
    loadPosts();
  }, []);

  const confirmDelete = (id: string) => {
    setSelectedPost(id);
    const modalElement = document.getElementById("deleteModal");
    if(modalElement){
      const modalInstance = new Modalclass(modalElement);
      modalInstance.show();
    }

  };

  async function handleDelete(id: string) {
      try{
        const res = await fetch(`${apiURL}/posts/${id}`, {
          method: 'DELETE',
        });
        if (!res.ok) throw new Error(`Failed: ${res.status}`);
        // const modalInstance = new Modalclass(document.getElementById("deleteModal"));
        // modalInstance.hide();
        setPosts(prevPosts => prevPosts.filter(post => post.id !== id));
        setAlert({ type:'success', message:"Deleted successfully."});
      }catch (error: any){
        setAlert({ type:'danger', message:`Error: ${error.message}` });
      }
  }

  return (
    <>
    {alert && (
      <div className={`alert alert-${alert.type} alert-dismissible fade show`} role="alert">
        {alert.message}
        <button type="button" className="btn-close" onClick={() => setAlert(null)}></button>
      </div>
    )}
    <div className="modal fade" id="deleteModal" tabIndex={-1} aria-labelledby="deleteModalLabel">
      <div className="modal-dialog">
        <div className="modal-content">
          <div className="modal-header bg-danger text-white">
            <h3 className="modal-title" id="deleteModalLabel">Confirm Delete</h3>
            <button type="button" className="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div className="modal-body">
            <p className="fw-bold">Are you sure want to delete this post? The result cannot be undone</p>
          </div>
          <div className="modal-footer">
            <button type="button" className="btn btn-primary" data-bs-dismiss="modal">Cancel</button>
            <button type="button" className="btn btn-danger" data-bs-dismiss="modal" onClick={() => handleDelete(selectedPost!)}>Delete</button>
          </div>
        </div>
      </div>
    </div>
      <h1>My Posts</h1>

      <a href="/posts/new" className="btn btn-primary mb-3">
        Create New Post
      </a>

      {loading ? (
        <div className="text-center">
          <div className="spinner-border" role="status">
            <span className="visually-hidden">Loading...</span>
          </div>
        </div>
      ) : error ? (
        <div className="alert alert-danger">
          <h4>Error</h4>
          <p>{error}</p>
          <button
            className="btn btn-primary"
            onClick={loadPosts}
          >
            Try Again
          </button>
        </div>
      ) : posts.length > 0 ? (
        <div>
          {posts.filter(post => !post.replyToId).map((post) => (
            <div key={post.id} className="post mb-4 p-3 border rounded">
              <div className="d-flex justify-content-between align-items-start mb-2">
                <h5 className="mb-0">
                  <strong>{post.posterName}</strong>
                </h5>
                <small className="text-muted">{post.createdAt}</small>
              </div>

              <p className="mb-2">
                <a href={`/posts/${post.id}`} className="text-dark text-decoration-none">
                  {post.content}
                </a>
              </p>

              <div className="mt-3">
                <a href={`/posts/${post.id}`} className="btn btn-sm btn-info me-2">
                  View
                </a>
                <a href={`/posts/${post.id}/reply`} className="btn btn-sm btn-success me-2">
                  Reply
                </a>
                <a href={`/posts/${post.id}/edit`} className="btn btn-sm btn-warning me-2">
                  Edit
                </a>
                <button
                  className="btn btn-sm btn-danger"
                  onClick={() => confirmDelete(post.id)}
                >
                  Delete
                </button>
              </div>

              {post.replies && post.replies.length > 0 && (
                <div className="mt-3 ms-3 border-start border-3 ps-3">
                  <h6 className="text-muted mb-3">Replies ({post.replies.length}):</h6>
                  {post.replies.map((reply) => (
                    <div key={reply.id} className="mb-2 p-2 bg-light rounded">
                      <div className="d-flex justify-content-between align-items-center mb-2">
                        <strong className="small">{reply.posterName}</strong>
                        <small className="text-muted">{reply.createdAt}</small>
                      </div>
                      <p className="mb-0 small">
                        <a href={`/posts/${reply.id}`} className="text-dark text-decoration-none">
                          {reply.content}
                        </a>
                      </p>
                    </div>
                  ))}
                </div>
              )}
            </div>
          ))}
        </div>
      ) : (
        <div className="alert alert-info">
          <h4>No posts yet</h4>
          <p>Be the first to create a post!</p>
          <a href="/posts/new" className="btn btn-primary">
            Create First Post
          </a>
        </div>
      )}
    </>
  );
}