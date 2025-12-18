import { useState } from "react";
import { useRouter } from "next/router";


export default function NewPost() {
  const [posterName, setPosterName] = useState("");
  const [content, setContent] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [alert, setAlert] = useState<{ type: string; message: string } | null>(null);
  const apiURL = process.env.NEXT_PUBLIC_API_URL
  console.log(apiURL);
  const router = useRouter();

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();

    if (!posterName.trim() || !content.trim()) return;

    setIsSubmitting(true);

    try{
      const res = await fetch(`${apiURL}/posts`,{
        method: 'POST',
        headers: {
          "content-type": "application/json",
        },
        body: JSON.stringify({ 
          posterName,
          content,
        }),
      });

      console.log("Post created:", {
        posterName: posterName.trim(),
        content: content.trim(),
        id: Date.now().toString(),
        createdAt: new Date().toISOString()
      });
      setAlert({type: "success", message: "Post created successfully!"});
      setTimeout(() => router.push("/"), 1500);
    } catch(error: any){
      setAlert({ type:"danger", message: `Cannot create post: ${error.message}`});
    }
    setIsSubmitting(false);
  }

  return (
    <>
      <h1>Create New Post</h1>
      {
        alert && (
          <div className={`alert alert-${alert.type} alert-dismissible fade show`} role="alert">
            { alert.message }
            <button type="button" className="btn-close" onClick={() => setAlert(null)}></button>
          </div>
        )
      }

      <form onSubmit={handleSubmit}>
        <div className="mb-3">
          <label htmlFor="posterName" className="form-label">
            Your Name
          </label>
          <input
            type="text"
            className="form-control"
            id="posterName"
            maxLength={100}
            required
            value={posterName}
            onChange={(e) => setPosterName(e.target.value)}
          />
        </div>

        <div className="mb-3">
          <label htmlFor="content" className="form-label">
            Content
          </label>
          <textarea
            className="form-control"
            id="content"
            rows={5}
            required
            placeholder="What's on your mind?"
            value={content}
            onChange={(e) => setContent(e.target.value)}
          />
        </div>

        <div className="d-flex gap-2">
          <button
            type="submit"
            className="btn btn-primary"
            disabled={isSubmitting}
          >
            {isSubmitting ? "Creating..." : "Create Post"}
          </button>
          <a href="/" className="btn btn-secondary">
            Cancel
          </a>
        </div>
      </form>
    </>
  );
}