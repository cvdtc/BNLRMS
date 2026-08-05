const fs = require('fs');
const path = require('path');

const saveAsJpg = (buffer, filename) => {
    const filePath = path.join(__dirname, '..', 'public', filename);
    fs.writeFileSync(filePath, buffer);
    return filePath;
}

module.exports = {
    saveAsJpg,
};