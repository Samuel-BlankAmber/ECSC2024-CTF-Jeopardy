const express = require('express');
const multer = require('multer');
const { Jimp } = require('jimp');
const jsQR = require('jsqr');
const fs = require('fs/promises');
const path = require('path');

const app = express();
const port = 3000;

process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";
const WEB_DOM = process.env.WEB_DOM || 'http://localhost';
const TARGET_PASSWORD = process.env.TARGET_PASSWORD || "582c963680f7ac49af20e30cfe6e5234"
const TARGET_USERNAME = "elkeke69";

const upload = multer({ dest: 'uploads/', limits: { fileSize: 1 * 1024 * 1024 } });

const decodeQRCode = async (imagePath) => {
    // Read the image with Jimp
    const image = await Jimp.read(imagePath);

    const imageData = {
        data: new Uint8ClampedArray(image.bitmap.data),
        width: image.bitmap.width,
        height: image.bitmap.height,
    };

    // Use jsQR to decode the QR code
    const decodedQR = jsQR(imageData.data, imageData.width, imageData.height);

    if (!decodedQR) {
        throw new Error('QR code not found in the image.');
    }

    return decodedQR.data;
};

app.post('/upload', upload.single('qrImage'), async (req, res) => {
    const filePath = req.file.path;

    try {
        const qrCodeContent = await decodeQRCode(filePath);

        // Login
        let request = await fetch(`${WEB_DOM}/api/v1/login/`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `username=${TARGET_USERNAME}&password=${TARGET_PASSWORD}`
        })

        if (!request.ok) {
            return res.send(`Error during login, please contact an admin`);
        }

        let response = await request.json();
        let token = response.session_token;

        let params = new URLSearchParams(qrCodeContent);
        let serial = params.get("serial");
        let comment = params.get("comment");

        console.log(`Serial: ${serial}`);
        console.log(`Comment: ${comment}`);

        response = await fetch(`${WEB_DOM}/api/v1/check/${serial}/`, {
            method: "POST",
            headers: {
                Authorization: token,
                "Content-Type": "application/x-www-form-urlencoded",
            },
            body: comment ? `comment=${comment}` : "",
        });

        if (response.ok) {
            return res.send("Ticket correctly checked");
        } else {
            return res.send("Ticket is invalid");
        }


    } catch (err) {
        res.status(500).send(`Error decoding QR code: ${err}`);
    } finally {
        try {
            await fs.unlink(filePath);
            console.log('File deleted successfully');
        } catch (err) {
            console.error('Error deleting file:', err);
        }
    }
});

app.get('/', (req, res) => {
    res.sendFile('index.html', {
        root: path.join(__dirname)
    });
});

app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
