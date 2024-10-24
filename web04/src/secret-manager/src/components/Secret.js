import React from 'react';
import { useParams } from 'react-router-dom';
import { useEffect, useState } from 'react';

function SecretList({ secrets }) {
    const { id } = useParams();
    const [secret, setSecret] = useState(null);

    useEffect(() => {
        fetch('/api/secret/' + id)
            .then(response => response.json())
            .then(data => setSecret(data))
            .catch(error => console.error('Error fetching secrets:', error));
    }, []);

    if (!secrets || secret === null) {
        return <div className='my-3'>Loading...</div>;
    }


    return (
        <div className="container mt-3">
            <div className="card">
                <div className="card-header">
                    <h1 className="card-title">{secret.name}</h1>
                </div>
                <div className="card-body">
                    <p className="card-text">{secret.content}</p>
                </div>
            </div>
        </div>
    );
}

export default SecretList;