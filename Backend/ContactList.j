import React, { useState, useEffect } from 'react';
import axios from 'axios';

const ContactList = () => {
    const [contacts, setContacts] = useState([]);

    useEffect(() => {
        axios.get('/api/contacts')
            .then(response => setContacts(response.data))
            .catch(error => console.error(error));
    }, []);

    return (
        <div>
            <h2>Contact List</h2>
            <ul>
                {contacts.map(contact => (
                    <li key={contact.id}>
                        {contact.name} - {contact.phoneNumber} - {contact.email}
                    </li>
                ))}
            </ul>
        </div>
    );
};
 
export default ContactList;
import React, { useState } from 'react';
import axios from 'axios';

const ContactForm = ({ contact, onSave }) => {
    const [name, setName] = useState(contact ? contact.name : '');
    const [phoneNumber, setPhoneNumber] = useState(contact ? contact.phoneNumber : '');
    const [email, setEmail] = useState(contact ? contact.email : '');

    const handleSubmit = (e) => {
        e.preventDefault();
        const newContact = { name, phoneNumber, email };
        if (contact) {
            axios.put(`/api/contacts/${contact.id}`, newContact)
                .then(response => onSave(response.data))
                .catch(error => console.error(error));
        } else {
            axios.post('/api/contacts', newContact)
                .then(response => onSave(response.data))
                .catch(error => console.error(error));
        }
    };

    return (
        <form onSubmit={handleSubmit}>
            <input type="text" value={name} onChange={(e) => setName(e.target.value)} placeholder="Name" required />
            <input type="text" value={phoneNumber} onChange={(e) => setPhoneNumber(e.target.value)} placeholder="Phone Number" required />
            <input type="email" value={email} onChange={(e) => setEmail(e.target.value)} placeholder="Email" required />
            <button type="submit">Save</button>
        </form>
    );
};

export default ContactForm;

import React, { useState } from 'react';
import axios from 'axios';

const ContactSearch = ({ onSearchResults }) => {
    const [query, setQuery] = useState('');

    const handleSearch = (e) => {
        e.preventDefault();
        axios.get(`/api/contacts/search?query=${query}`)
            .then(response => onSearchResults(response.data))
            .catch(error => console.error(error));
    };

    return (
        <form onSubmit={handleSearch}>
            <input type="text" value={query} onChange={(e) => setQuery(e.target.value)} placeholder="Search" required />
            <button type="submit">Search</button>
        </form>
    );
};

export default ContactSearch;

import React, { useState } from 'react';
import ContactList from './components/ContactList';
import ContactForm from './components/ContactForm';
import ContactSearch from './components/ContactSearch';

const App = () => {
    const [contacts, setContacts] = useState([]);

    const handleSave = (newContact) => {
        setContacts([...contacts, newContact]);
    };

    const handleSearchResults = (results) => {
        setContacts(results);
    };

    return (
        <div>
            <h1>Contact Manager</h1>
            <ContactForm onSave={handleSave} />
            <ContactSearch onSearchResults={handleSearchResults} />
            <ContactList contacts={contacts} />
        </div>
    );
};

export default App;

import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';

ReactDOM.render(
    <React.StrictMode>
        <App />
    </React.StrictMode>,
    document.getElementById('root')
);
