import React from 'react';
import { Link } from 'react-router-dom';

function SecretList({ secrets }) {
    if (!secrets) {
        return <div  className="my-3">Loading...</div>;
    }

    if (secrets.length === 0) {
        return <div className="my-3">
            No secrets found
            <br />
            Create a new secret <Link to="/new">here</Link>
        </div>;
    }

    return (
        <div className="container mt-4">
            <h1 className="mb-4">Your secrets</h1>
            <ul className="list-group">
            {secrets.map((secret, index) => (
                <li key={index} className="list-group-item">
                    <Link to={`/secret/${secret.id}`}>{secret.name}</Link>
                </li>
            ))}
            </ul>
        </div>
    );
}

export default SecretList;