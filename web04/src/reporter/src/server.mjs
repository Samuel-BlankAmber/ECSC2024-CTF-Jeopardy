import express from 'express';
import 'express-async-errors';

const app = express();

app.set('view engine', 'ejs');
app.use(express.urlencoded({ extended: false }));

app.get('/report', (req, res) => {
    res.render('report');
});

app.post('/report', async (req, res) => {
    const { url, job } = req.body;

    if (url)  {

        console.log('report:', url);

        if (!url || (!url.startsWith('http://') && !url.startsWith('https://'))) {
            return res.render('report', { err: 'Bad url' });
        }
        try {
            const r = await fetch('http://' + process.env.HEADLESS_HOST, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Auth': process.env.HEADLESS_AUTH,
                },
                body: JSON.stringify({
                    actions : [
                        {
                            type: 'request',
                            url: process.env.CHALL_URL + '/demo',
                        },
                        {
                            type: 'type',
                            element: 'input[name="name"]',
                            value: 'flag'
                        },
                        {
                            type: 'type',
                            element: 'input[name="secret"]',
                            value: process.env.FLAG
                        },                {
                            type: 'type',
                            element: 'input[name="name"]',
                            value: process.env.FLAG
                        },
                        {
                            type: 'click',
                            element: 'button[type="submit"]'
                        },
                        {
                            type: 'request',
                            url: url
                        },
                        {
                            type: 'sleep',
                            time: 10
                        }
                    ],
                    browser: 'chrome',
                }),
            });

            if (r.status !== 200) {
                console.error('Bad headless request:', r.status, await r.text());
                return res.render('report', { err: 'We have some problem with the headless, please contact an admin' });
            }

            const { job } = await r.json();

            return res.render('report', { msg: 'Job submitted - ' + job, job });
        } catch (e) {
            console.error(e);
            return res.render('report', { err: 'We have some problem with the headless, please contact an admin' });
        }
    } else if (job) {
        // check job status
        try {
            if (!job.match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/)) {
                return res.render('report', { err: 'Bad job id' });
            }

            const r = await fetch('http://' + process.env.HEADLESS_HOST + '/jobs/' + job, {
                headers: {
                    'X-Auth': process.env.HEADLESS_AUTH,
                },
            });

            if (r.status !== 200) {
                console.error('Bad headless request:', r.status, await r.text());
                return res.render('report', { err: 'We have some problem with the headless, please contact an admin', job });
            }

            const { status } = await r.json();

            return res.render('report', { msg: 'Job status: ' + status, job });
        } catch (e) {
            console.error(e);
            return res.render('report', { err: 'We have some problem with the headless, please contact an admin', job });
        }
    }

    res.render('report', { err: 'Bad request' });

});

app.listen(3000, () => {
    console.log('Listening on http://localhost:3000');
});
