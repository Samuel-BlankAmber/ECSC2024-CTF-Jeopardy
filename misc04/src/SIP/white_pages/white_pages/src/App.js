import { Table, Container, Badge, Spinner, Alert } from "react-bootstrap";
import 'bootstrap/dist/css/bootstrap.min.css'; // Import Bootstrap styles
import React, { useEffect, useState } from "react";

//const fake_response = [{"id":1,"status":1},{"id":2,"status":0},{"id":3,"status":0},{"id":4,"status":0},{"id":5,"status":0},{"id":6,"status":0},{"id":7,"status":0},{"id":8,"status":0},{"id":9,"status":0},{"id":10,"status":0},{"id":11,"status":0},{"id":12,"status":0},{"id":13,"status":0},{"id":14,"status":0},{"id":15,"status":0},{"id":16,"status":0},{"id":17,"status":0},{"id":18,"status":0},{"id":19,"status":0},{"id":20,"status":0},{"id":21,"status":0},{"id":22,"status":0},{"id":23,"status":0},{"id":24,"status":0},{"id":25,"status":0},{"id":26,"status":0},{"id":27,"status":0},{"id":28,"status":0},{"id":29,"status":0},{"id":30,"status":0},{"id":31,"status":0},{"id":32,"status":0},{"id":33,"status":0},{"id":34,"status":0},{"id":35,"status":0},{"id":36,"status":0},{"id":37,"status":0}];
const team_id_map = {0: 'NOP', 1: 'Albania', 2: 'Australia', 3: 'Austria', 4: 'Belgium', 5: 'Bulgaria', 6: 'Canada', 7: 'Costa Rica', 8: 'Croatia', 9: 'Cyprus', 10: 'Czech Republic', 11: 'Denmark', 12: 'Estonia', 13: 'Finland', 14: 'France', 15: 'Germany', 16: 'Greece', 17: 'Hungary', 18: 'Iceland', 19: 'Ireland', 20: 'Italy', 21: 'Kosovo', 22: 'Latvia', 23: 'Liechtenstein', 24: 'Luxembourg', 25: 'Netherlands', 26: 'Norway', 27: 'Poland', 28: 'Portugal', 29: 'Romania', 30: 'Serbia', 31: 'Singapore', 32: 'Slovakia', 33: 'Slovenia', 34: 'Spain', 35: 'Sweden', 36: 'Switzerland', 37: 'USA'}


function App() {
  // State to hold the fetched status data
  const [statusData, setStatusData] = useState([]);
  const [loading, setLoading] = useState(true); // Loading state
  const [error, setError] = useState(null); // Error state

  // Fetch status data from the /status endpoint
  useEffect(() => {
    fetch("/status")
      .then((response) => {
        if (!response.ok) {
          throw new Error("Failed to fetch data");
        }
        return response.json();
      })
      .then((data) => {
        setStatusData(data); // Set data to the state
        setLoading(false);   // Disable loading state
      })
      .catch((err) => {
        setError(err.message); // Set the error message
        setLoading(false);      // Disable loading state
      });
  }, []);

  if (loading) {
    return (
      <Container className="text-center mt-5">
        <Spinner animation="border" variant="primary" /> {/* Spinner for loading */}
        <p>Loading...</p>
      </Container>
    );
  }

  if (error) {
    return (
      <Container className="mt-5">
        <Alert variant="danger">
          <strong>Error:</strong> {error}
        </Alert>
      </Container>
    );
  }

  return (
    <Container className="mt-5">
      <h1 className="text-center mb-4">Teams Status</h1>
      <Table striped bordered hover responsive="sm" className="text-center">
        <thead>
          <tr>
            <th>Team</th>
            <th>Phone number</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          {statusData.map((item) => (
            <tr key={item.id}>
              <td>{team_id_map[item.id]}</td>
              <td>{item.id.toString().padStart(4, '0')}</td>
              <td>
                {item.status === 1 ? (
                  <Badge pill bg="success">
                    Available
                  </Badge>
                ) : (
                  <Badge pill bg="danger">
                    Unavailable
                  </Badge>
                )}
              </td>
            </tr>
          ))}
        </tbody>
      </Table>
    </Container>
  );
}

export default App;
