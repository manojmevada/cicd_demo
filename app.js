const express = require("express");

const app = express();
const PORT = 3000;

app.get("/", (req, res) => {
  res.send("Node CI/CD App Running 🚀!");
});

app.get("/health", (req, res) => {
  res.json({ status: "ok", timestamp: new Date().toISOString() });
});

app.listen(PORT, () => {
  console.log(`Server started on port ${PORT}`);
  console.log(`Access the app at http://localhost:${PORT}`);
});
