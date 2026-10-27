FROM node:24-bookworm-slim

WORKDIR /app

# Création d'un serveur HTTP natif servant le HTML et la route /api/health sur le port 3000
RUN echo 'const http = require("http");\n\
const fs = require("fs");\n\
const path = require("path");\n\
const html = fs.readFileSync(path.join(__dirname, "index.html"));\n\
\n\
const server = http.createServer((req, res) => {\n\
  if (req.url.endsWith("/api/health") || req.url === "/api/health") {\n\
    res.writeHead(200, { "Content-Type": "application/json" });\n\
    return res.end(JSON.stringify({ status: "ok" }));\n\
  }\n\
  res.writeHead(200, { "Content-Type": "text/html; charset=utf-8" });\n\
  res.end(html);\n\
});\n\
\n\
server.listen(3000, "0.0.0.0", () => {\n\
  console.log("Serveur GymFlow prêt sur le port 3000");\n\
});' > server.js

COPY index.html ./

USER 1000
EXPOSE 3000

CMD ["node", "server.js"]
