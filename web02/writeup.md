# ECSC 2024 - Jeopardy

## [web] PhpMySecureAdmin (3 solves)

Let's do some programming together!!!

We offer a demo for phpMyAdmin and a pretty js console.

phpMyAdmin: [https://db.phpmysecureadmin.xyz](https://db.phpmysecureadmin.xyz)
jsConsole: [http://console.phpmysecureadmin.xyz](http://console.phpmysecureadmin.xyz)

P.S. local deployment doesn't have https on phpmyadmin. The bot reaches the challenge with the same domains.

Author: Alessanro Mizzaro <@Alemmi>

## Overview

The challenge has two subdomains __SameSite__

- db.__phpmysecureadmin.it__
- console.__phpmysecureadmin.it__

The first service is a deployment of the PHPMyAdmin master branch.

The second service is a js console deployment, an XSS as a service that can be used with

```text
http://console.phpmysecureadmin.it?<jscode>
```

A notable difference between the two deployments is that PHPMyAdmin has https, and the console does not. Reminder this for later.

There are two principal custom files in PHPMyAdmin, `create-user.php` and  `bot.php`.  The first one allows a non-authenticated user to create a MySQL user with a DB and a table flag. The second one creates a user for the bot, show the username on the screen, and call the bot with the provided url.

The bot will:

- Navigate to PHPMyAdmin
- Login
- Visit the provided URL
- Return to PHPMyAdmin
- Select his db
- Select the table flag
- Click on Insert
- Add the flag to his table.

So we have to two domain SameSite, and one of that is an XSS as a service, we need to do something with cookies.

## Solution

### Bot problems

If we check the bot code, we can see that all the selectors of db/tables are in the form

```css
a[href*="{route_and_options}&db=$bot_username"]
```

This selector is a substring selector, so the bot can select all the db __starting with__ `$bot_username`, for example, `$bot_username + "meow"`.

### PHPMyAdmin

In the master branch of PHPMyAdmin, they have [enabled](`https://github.com/phpmyadmin/phpmyadmin/commit/0631cdf07f35a9e9497c24a23f253a8180556c17`) the  `__Secure` cookie prefix to prevent cookie smuggling.
For a security issue, We have turned off the https on `console`, so the user cannot simply overwrite the `__Secure` cookie, but I used PHP `8.2.0`, which is vulnerable due to a partial fix of `CVE-2022-31629` ([advisory](https://github.com/php/php-src/security/advisories/GHSA-wpj3-hf5j-x4v4))

## Exploit

The chain, at this point, is pretty straightforward.

- Take the username from `bot.php`; let's call it `$bot_username`
- Register a username with `$bot_username` as prefix via `create_user.php`
- Login via PHPMyAdmin and save the cookies
- Craft a URL to the console that sets all the cookies with `_[Secure` as a prefix with a more restrictive path pointing to `/public/index.php` and a domain set to `.phpmysecureadmin.xyz`.

Example:

```javascript
document.cookie='_[Secure-phpMyAdmin_https={session};path=/public/index.php;domain=.phpmysecureadmin.xyz'
```

- Submit the URL to the bot.
- The bot will now log in, visit your URL, and get your cookies. When it returns to PHPMyAdmin, it will be logged in as you, so the bot will insert the flag in your DB. Enjoy!!
