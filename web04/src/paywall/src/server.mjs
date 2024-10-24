import express from 'express';
import session from 'express-session';
import crypto from 'crypto';
import captchapng from 'captchapng';
import fs from 'fs';
import path from 'path';
import 'express-async-errors';

const N_CAPTCHAS = 15;
const PASSWORD = process.env.PASSWORD;

const app = express();

app.use(session({
    secret: crypto.randomBytes(20).toString('hex'),
    resave: false,
    saveUninitialized: true,
    cookie: { secure: false }
}));

app.set('view engine', 'ejs');
app.use(express.urlencoded({ extended: false }));

app.use((req, res, next) => {
    const nonce = crypto.randomBytes(20).toString('hex');
    res.locals.nonce = nonce;
    res.setHeader('Content-Security-Policy', `script-src 'self' 'nonce-${nonce}';`);

    if (req.session.user) {
        res.locals.user = req.session.user;
    }

    next();
});

app.get('/', (req, res) => {
    res.render('index');
});

app.get('/login', (req, res) => {
    res.render('login');
});

app.post('/login', (req, res) => {
    const { username, password } = req.body;

    // todo implement real login ¯\_(ツ)_/¯
    req.session.user = username;
    req.session.captcha = '';
    req.session.captcha_i = 0;

    res.redirect('/');
});

app.get('/logout', (req, res) => {
    req.session.destroy();
    res.redirect('/');
});

app.get('/demo', (req, res) => {
    res.render('demo');
});

app.use((req, res, next) => {
    if (!res.locals.user) {
        return res.redirect('/login');
    }
    next();
});

app.get('/pay', (req, res) => {
    res.render('pay',  { card: req.query.card || '' });
});

app.get('/captcha', (req, res) => {

    if (!req.session.user) {
        console.log(req.session)
        return res.redirect('/login');
    }

    if (req.session.captcha === '') {

        let captcha_length = Math.min(21, req.session.captcha_i ** 2 + 2);
        let captcha = '';

        for (let i = 0; i < captcha_length; i++) {
            captcha += crypto.randomInt(10);
        }

        req.session.captcha = captcha;


        var p = new captchapng(25*captcha_length,30,parseInt(captcha));
        p.color(0, 0, 0, 0);
        p.color(80, 80, 80, 255);


        const img = p.getDump();

        fs.writeFile(path.join( '/tmp/', req.session.user), img, 'binary', (err)=>{ console.log(err); });
    }

    res.render('captcha', { captcha_i : req.session.captcha_i, captcha_n : N_CAPTCHAS});
});

app.post('/captcha', (req, res) => {
    const { captcha } = req.body;

    console.log('captcha:', captcha);
    console.log('session:', req.session.captcha);

    if (req.session.captcha === captcha) {

        req.session.captcha = '';
        req.session.captcha_i += 1;

        if (req.session.captcha_i >= N_CAPTCHAS) {
            return res.redirect('/get-access');
        }

    } else {

        if (req.session.captcha_i > 0) {
            req.session.captcha_i -= 1;
        }

        return res.render('captcha', { captcha_i : req.session.captcha_i, captcha_n : N_CAPTCHAS, err: 'Invalid captcha'});
    }

    res.redirect('/captcha');

});

app.get('/captcha.png', (req, res) => {
    res.setHeader('Content-Type', 'image/png');
    res.send(fs.readFileSync(path.join( '/tmp/', req.session.user)));
});

app.get('/get-access', (req, res) => {
    if (req.session.captcha_i >= N_CAPTCHAS) {
        return res.render('get-access', { success: true, url: `http://user:${PASSWORD}@${req.headers.host}/app` });
    }

    res.render('get-access', { success: false, url: 'TEST' });
});


app.listen(3000, () => {
    console.log('Server is running on port 3000');
});
