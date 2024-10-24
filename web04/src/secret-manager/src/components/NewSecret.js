import React, { useState } from 'react';

function NewSecret({ addSecret }) {
    const [secret, setSecret] = useState('');
    const [name, setName] = useState('');

    const handleSecretInputChange = (event) => {
        setSecret(event.target.value);
    };

    const handleNameInputChange = (event) => {
        setName(event.target.value);
    };

    const handleSubmit = (event) => {
        event.preventDefault();
        
        addSecret(name, secret);

        setSecret('');
        setName('');

        alert('Secret added');
    };

    return (
        <form onSubmit={handleSubmit} className="p-4 border rounded my-3">
            <div className="mb-3">
                <label className="form-label">Name</label>
                <input 
                    type="text" 
                    value={name} 
                    onChange={handleNameInputChange} 
                    className="form-control" 
                />
            </div>
            <div className="mb-3">
                <label className="form-label">Secret</label>
                <input 
                    type="text" 
                    value={secret} 
                    onChange={handleSecretInputChange}  
                    className="form-control" 
                />
            </div>
            <button type="submit" className="btn btn-primary">Add Secret</button>
        </form>
    );
}

export default NewSecret;