#set text(font: "Atkinson Hyperlegible")
#set par(justify: true)

== File Upload: Multer vs S3 (Presigned URL)

This section outlines the comparison between two common approaches for handling file uploads in a backend system: Multer, a traditional server-side upload middleware, and S3 Presigned URLs, a modern cloud-based upload strategy. Both approaches serve the same purpose—accepting files from clients—but differ significantly in terms of architecture, security, performance, and scalability.

Understanding their differences is essential when designing a system that involves user-generated media, such as posts with images in a Twitter-like application.

== Multer: Traditional Server-Side Uploads

Multer is a Node.js middleware commonly used to handle multipart/form-data uploads. In this model, the file is sent directly to the backend server, which receives, processes, and stores it (either locally or by uploading it to another storage service).

=== How Multer Works

+ The client sends a multipart/form-data request containing a file.

+ The server receives the file via Multer.

+ The file is temporarily stored in memory or disk.

+ The server optionally uploads the file to another storage service or saves it locally.

=== Advantages of Multer

- Simple and beginner-friendly.
Ideal for small projects or quick prototypes.

- Immediate access for processing.
- The server can manipulate files (resize, compress, filter) before storing them.

- No external storage required.
- Files can be stored directly in the local filesystem.

=== Limitations of Multer

+ Increased server load.
Large files consume CPU, RAM, and bandwidth.

+ Limited scalability.
In production environments—or applications like social platforms—servers quickly become bottlenecks.

+ Security concerns.
Every uploaded file passes through your server, increasing exposure to malicious payloads.

+ Not suitable for distributed deployments.
Using local disk storage becomes problematic when running multiple backend instances.

== S3 Presigned URL: Direct Cloud Upload

A more scalable and modern approach is to let clients upload files directly to a cloud storage service (e.g., AWS S3 or MinIO). The backend does not handle the file itself. Instead, it generates a presigned URL, which grants temporary permission for the client to upload.

=== How S3 Presigned URLs Work

+ The client requests an upload URL from the backend.

+ The backend generates a time-limited URL specific to the file.

+ The client uploads the file directly to the storage bucket.

+ The backend only stores file metadata such as its storage path.

=== Advantages of S3 Presigned URLs

+ Highly scalable.
The server no longer handles or forwards heavy file payloads.

+ Better security.
The presigned URL is temporary and tightly scoped.

+ Lower infrastructure cost.
Servers consume far fewer resources since upload traffic bypasses them.

+ Faster uploads.
Clients upload directly to the storage provider, often through optimized and globally-distributed endpoints.

+ Cloud-native architecture.
Ideal for modern systems, microservices, and serverless environments.

=== Limitations of S3 Presigned URLs
- Slightly more complex to implement.
Requires generating presigned URLs and configuring cloud bucket policies.
- No server-side pre-processing.
- Any resizing or compression must be done on the client or through cloud functions (e.g., Lambda triggers).
- Requires external storage services.

== Side-by-Side Comparison

Category	Multer	S3 Presigned URL
Architecture	File passes through backend	File uploads directly to storage
Server Load	High	Extremely low
Upload Speed	Limited by backend's bandwidth	Optimized (direct to cloud)
Security	Medium	High (scoped temporary URLs)
Scalability	Poor	Excellent
Ease of Implementation	Simple	Moderate
Server-side Processing	Supported	Not supported (client/cloud only)

== When to Use Multer

- Prototyping or small-scale applications.

- Projects requiring immediate server-side processing (resizing, filtering, transformation).

- Environments where external storage is not available or not necessary.

== When to Use S3 Presigned URLs

- Applications expected to scale (social platforms, media-heavy apps).

- Systems that prioritize performance, cost efficiency, and high availability.

- Architectures where backend servers should not handle file uploads directly.

- Deployments using CDNs or distributed cloud storage.

== Conclusion
Both Multer and S3 Presigned URLs are valid approaches depending on the scale and requirements of the application. Multer excels in simplicity and server-side processing, making it suitable for lightweight use cases. However, for production-grade systems—especially those involving high upload volume or large media files—S3 Presigned URLs provide superior performance, scalability, and security, offering a cloud-native solution aligned with modern backend architecture principles.