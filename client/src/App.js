import "./App.css";

function App() {
  return (
    <div className="App">
      <div className="hero">
        <div className="pill">Frontend live on :80 · Nginx + Docker</div>
        <h1>React App 2 · Playground</h1>
        <p className="subtitle">
          Static build served by nginx. API calls are proxied to the backend
          containers on port 5000.
        </p>

        <div className="actions">
          <a href="http://localhost/api/health" className="btn success">
            Check API Health
          </a>
          <a href="http://localhost/api/hello" className="btn primary">
            /api/hello
          </a>
          <a href="http://localhost/api/items" className="btn purple">
            GET /api/items
          </a>
          <a
            href="https://httpie.io/docs/cli"
            target="_blank"
            rel="noreferrer"
            className="btn ghost"
          >
            Try POST /api/echo
          </a>
        </div>

        <div className="panels">
          <div className="panel">
            <div className="panel-title">Quick API checks (curl)</div>
            <pre>{`curl -i http://localhost/api/health
curl -i http://localhost/api/hello
curl -i http://localhost/api/items
curl -i -X POST http://localhost/api/echo \\
  -H "Content-Type: application/json" \\
  -d '{"name":"demo"}'`}</pre>
          </div>
          <div className="panel">
            <div className="panel-title">Backend routes</div>
            <ul>
              <li>GET /health – service status</li>
              <li>GET /api/hello – simple JSON hello</li>
              <li>POST /api/echo – echoes your JSON body</li>
              <li>GET /api/items – list MongoDB items</li>
              <li>POST /api/items – create item {`{ name }`}</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  );
}

export default App;
