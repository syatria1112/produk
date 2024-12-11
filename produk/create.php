const express = require('express');
const multer = require('multer');
const path = require('path');
const app = express();

// Konfigurasi penyimpanan file
const storage = multer.diskStorage({
    destination: './uploads/',
    filename: function (req, file, cb) {
        cb(null, Date.now() + path.extname(file.originalname));
    }
});

const upload = multer({ storage: storage });

// Middleware untuk parsing JSON dan URL-encoded
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Set folder public dan views
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
app.use(express.static(path.join(__dirname, 'views')));

// Endpoint untuk halaman unggah konten
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'views', 'upload.html'));
});

// Endpoint untuk menangani unggahan konten
app.post('/upload', upload.single('file'), (req, res) => {
    const { title, content } = req.body;
    const filePath = `/uploads/${req.file.filename}`;

    // Simpan konten di database (contoh: gunakan array sementara)
    const post = {
        title: title,
        content: content,
        filePath: filePath,
        createdAt: new Date()
    };
    posts.push(post); // Menyimpan ke array untuk contoh, gunakan DB di produksi
    res.redirect('/dashboard'); // Redirect ke dashboard setelah unggah
});

// Endpoint untuk mengambil konten untuk dashboard
app.get('/getContents', (req, res) => {
    res.json(posts);
});

// Menampilkan halaman dashboard
app.get('/dashboard', (req, res) => {
    res.sendFile(path.join(__dirname, 'views', 'dashboard.html'));
});

// Jalankan server
app.listen(3000, () => console.log('Server running on http://localhost:3000'));
