// functions/index.js

const functions = require("firebase-functions");
const fetch = require("node-fetch");

/**
 * Cloud Function HTTP que recibe un parámetro "url" por query-string,
 * hace un fetch a esa URL y responde con el HTML obtenido, habilitando CORS.
 */
exports.fetchHtmlProxy = functions.https.onRequest(async (req, res) => {
  // Permitir llamadas de cualquier dominio (CORS):
  res.set("Access-Control-Allow-Origin", "*");

  // Si el método es OPTIONS (preflight de CORS), responder inmediatamente:
  if (req.method === "OPTIONS") {
    res.set("Access-Control-Allow-Methods", "GET, POST");
    res.set("Access-Control-Allow-Headers", "Content-Type");
    return res.status(204).send("");
  }

  // Obtener la URL desde el query string: ?url=...
  const url = req.query.url;
  if (!url) {
    return res.status(400).send("Debe proveer el parámetro \"url\"");
  }

  try {
    // Hacemos fetch a la URL externa
    const response = await fetch(url);
    const html = await response.text();

    // Forzar el tipo de contenido a HTML
    res.set("Content-Type", "text/html; charset=UTF-8");
    return res.status(response.status).send(html);
  } catch (err) {
    console.error("Error al descargar la URL:", err);
    return res.status(500).send("Error al descargar el contenido de la URL");
  }
});
