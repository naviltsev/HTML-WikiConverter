use Test::More;

local $/;
my @tests = split /\+\+\+\+\n/, <DATA>;

plan tests => scalar @tests + 1;

use HTML::WikiConverter;
my $wc = new HTML::WikiConverter(
  dialect => 'MediaWiki',
  base_uri => 'http://www.test.com',
  wiki_uri => 'http://www.test.com/wiki/',
  wrap_in_html => 1
);

foreach my $test ( @tests ) {
  $test =~ s/^(.*?)\n//; my $name = $1;
  my( $html, $wiki ) = split /\+\+/, $test;
  for( $html, $wiki ) { s/^\n+//; s/\n+$// }
  is( $wc->html2wiki($html), $wiki, $name );
}

$wc->base_uri( '' );
$wc->wiki_uri( '' );
is(
  $wc->html2wiki('<html><a href="http://www.getfirefox.com">Firefox</a></html>'),
  '[http://www.getfirefox.com Firefox]',
  'external link w/o wiki_uri'
);

__DATA__
wrap in html
<a href="http://google.com">GOOGLE</a><br/>
NewLine
++
[http://google.com GOOGLE]<br /> NewLine
++++
bold
<html><b>bold</b></html>
++
'''bold'''
++++
italics
<html><i>italics</i></html>
++
''italics''
++++
bold and italics
<html><b>bold</b> and <i>italics</i></html>
++
'''bold''' and ''italics''
++++
bold-italics nested
<html><b><i>bold-italics</i> nested</b></html>
++
'''''bold-italics'' nested'''
++++
strong
<html><strong>strong</strong></html>
++
'''strong'''
++++
emphasized
<html><em>emphasized</em></html>
++
''emphasized''
++++
underlined
<html><u>underlined</u></html>
++
<u>underlined</u>
++++
strikethrough
<html><s>strike</s></html>
++
<s>strike</s>
++++
deleted
<html><del>deleted text</del></html>
++
<del>deleted text</del>
++++
inserted
<html><ins>inserted</ins></html>
++
<ins>inserted</ins>
++++
span
<html><span>span</span></html>
++
<span>span</span>
++++
strip aname
<html><a name="thing"></a></html>
++

++++
one-line phrasals
<html><i>phrasals
in one line</i></html>
++
''phrasals in one line''
++++
paragraph blocking
<html><p>p1</p><p>p2</p></html>
++
p1

p2
++++
lists
<html><ul><li>1</li><li>2</li></ul></html>
++
* 1
* 2
++++
nested lists
<html><ul><li>1<ul><li>1a</li><li>1b</li></ul></li><li>2</li></ul>
++
* 1
** 1a
** 1b
* 2
++++
nested lists (different types)
<html><ul><li>1<ul><li>a<ol><li>i</li></ol></li><li>b</li></ul></li><li>2<dl><dd>indented</dd></dl></li></ul></html>
++
* 1
** a
**# i
** b
* 2
*: indented
++++
hr
<html><hr /></html>
++
----
++++
br
<html><p>stuff<br />stuff two</p></html>
++
stuff<br />stuff two
++++
div
<html><div>thing</div></html>
++
<div>thing</div>
++++
div w/ attrs
<html><div id="name" class="panel" onclick="popup()">thing</div></html>
++
<div id="name" class="panel">thing</div>
++++
sub
<html><p>H<sub>2</sub>O</p></html>
++
H<sub>2</sub>O
++++
sup
<html><p>x<sup>2</sup></p></html>
++
x<sup>2</sup>
++++
center
<html><center>centered text</center></html>
++
<center>centered text</center>
++++
small
<html><small>small text</small></html>
++
<small>small text</small>
++++
code
<html><code>$name = 'stan';</code></html>
++
<code>$name = 'stan';</code>
++++
tt
<html><tt>tt text</tt></html>
++
<tt>tt text</tt>
++++
font
<html><font color="blue" face="Arial" size="+2">font</font></html>
++
<font size="+2" color="blue" face="Arial">font</font>
++++
pre
<html><pre>this
  is
    preformatted
      text</pre></html>
++
 this
   is
     preformatted
       text
++++
indent
<html><dl><dd>indented text</dd></dl></html>
++
: indented text
++++
nested indent
<html><dl><dd>stuff<dl><dd>double-indented</dd></dl></dd></dl></html>
++
: stuff
:: double-indented
++++
h1
<h1>h1</h1>
++
= h1 =
++++
h2
<h2>h2</h2>
++
== h2 ==
++++
h3
<h3>h3</h3>
++
=== h3 ===
++++
h4
<h4>h4</h4>
++
==== h4 ====
++++
h5
<h5>h5</h5>
++
===== h5 =====
++++
h6
<h6>h6</h6>
++
====== h6 ======
++++
img
<html><img src="thing.gif" /></html>
++
[[Image:thing.gif]]
++++
table
<table>
  <caption>Stuff</caption>
  <tr>
    <th> Name </th> <td> David </td>
  </tr>
  <tr>
    <th> Age </th> <td> 24 </td>
  </tr>
  <tr>
    <th> Height </th> <td> 6' </td>
  </tr>
  <tr>
    <td>
      <table>
        <tr>
          <td> Nested </td>
          <td> tables </td>
        </tr>
        <tr>
          <td> are </td>
          <td> fun </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
++
{|
|+ Stuff
|-
! Name
| David
|-
! Age
| 24
|-
! Height
| 6'
|-
|
{|
| Nested
| tables
|-
| are
| fun
|}
|}
++++
table w/ attrs
<table border=1 cellpadding=3 bgcolor=#ffffff onclick='alert("alert!")'>
  <caption>Stuff</caption>
  <tr id="first" class="unselected">
    <th id=thing bgcolor=black> Name </th> <td> Foo </td>
  </tr>
  <tr class="selected">
    <th> Age </th> <td>24</td>
  </tr>
  <tr class="unselected">
    <th> <u>Height</u> </th> <td> 6' </td>
  </tr>
</table>
++
{| border="1" cellpadding="3" bgcolor="#ffffff"
|+ Stuff
|- id="first" class="unselected"
! id="thing" bgcolor="black" | Name
| Foo
|- class="selected"
! Age
| 24
|- class="unselected"
! <u>Height</u>
| 6'
|}
++++
table w/ blocks
<table>
  <tr>
    <td align=center>
      <p>Paragraph 1</p>
      <p>Paragraph 2</p>
    </td>
  </tr>
</table>
++
{|
| align="center" |
Paragraph 1

Paragraph 2
|}
++++
strip empty aname
<html><a name="thing"></a> some text</html>
++
some text
++++
wiki link (text == title)
<html><a href="/wiki/Some_wiki_page">Some wiki page</a></html>
++
[[Some wiki page]]
++++
wiki link (text case != title case)
<html><a href="/wiki/Another_page">another page</a></html>
++
[[another page]]
++++
wiki link (text != title)
<html><a href="/wiki/Another_page">some text</a></html>
++
[[Another page|some text]]
++++
external links
<html><a href="http://www.test.com">thing</a></html>
++
[http://www.test.com thing]
++++
external links (rel2abs)
<html><a href="thing.html">thing</a></html>
++
[http://www.test.com/thing.html thing]
++++
strip urlexpansion
<html><a href="http://www.google.com">Google</a> <span class=" urlexpansion ">(http://www.google.com)</span></html>
++
[http://www.google.com Google]
++++
strip printfooter
<html><div class="printfooter">Retrieved from blah blah</div></html>
++

++++
strip catlinks
<html><div id="catlinks"><p>Categories: ...</p></div></html>
++

++++
strip editsection
<html>This is <div class="editsection" style="..."><a href="?action=edit&section=1">edit</a></div> great</html>
++
This is

great
++++
escape bracketed urls
<html><p>This is a text node with what looks like an ext. link [http://example.org].</p></html>
++
This is a text node with what looks like an ext. link <nowiki>[http://example.org]</nowiki>.
++++
complete example
<html>
<head>
  <title>Complete example</title>
  <script type="text/javascript"><!--
  function doSomething() { alert('hello!'); }
  //--></script>
  <style type="text/css">
  body { font-size: 12pt; background:#ccc }
  h1, h2, h3 { font-family: verdana, sans-serif }
  </style>
</head>
<body>
<hr />

<p>
Hello, my <i>name</i> is <b>Jonas</b>! I carry the <u>wind</u>.
Thanks for <em>all</em> you've shown us...

  <pre>Stuff <tt id='goes' class='text' onclick='openwin()'>goes</tt> here
    and it's preformatted,
      m'kay?</pre>

Let's see how this paragraph was handled... Excellent! Now how about a
link: Get <a href="http://www.getfirefox.com">Firefox</a> and free
yourself from madness!

</p>

<ul>
  <li> frog
    <ul>
      <li> pacman frog
        <ol>
          <li> mouth
          <li> stomach
        </ol>
      </li>
    </ul>
  </li>
  <li> mouse
</ul>

<img src="http://www.google.com/images/logo.gif"/>

<ul>
  <li>1
    <ul>
      <li>1a</li>
      <li>1b</li>
    </ul>
  </li>
  <li>2
    <ul>
      <li>2a
        <ol>
          <li>fee</li>
          <li>fie</li>
          <li>foe
            <ul>
              <li>fum</li>
            </ul>
          </li>
        </ol>
      </li>
    </ul>
  </li>
  <li> e
    <dl>
      <dd>This is some fancy indented text</dd>
    </dl>
  </li>
  <li>3
    <dl>
      <dt>Cookies</dt>
      <dd>Delicious delicacies</dd>
    </dl>
  </li>
</ul>

<dl><dd> One
<dl><dd> Two
<dl><dd> Three
</dd></dl>
</dd></dl>
</dd></dl>

<dl>
  <dt> Gubaba </dt>
  <dd> See Diberri </dd>
</dl>

<h1>
  Heading
  One
</h1>
<p> Content of section one. </p>
<h2> Heading </h2>
<p> Section two content </p>
<h3> Heading </h3>
<p> Crazy section three! </p>

<pre> Superman is my favorite superhero.
   This is pre-
     <i>formatted</i> text.
       And you should be proud
   that it's working.</pre>

<ul>
  <li> Do you <strong>love</strong> me? </li>
  <li> <em>Do you love me?</em> </li>
  <li> <b><i>It's a</i> boy!</b> </li>
</ul>

<table>
  <caption>Stuff</caption>
  <tr>
    <td> Name </td> <td> David </td>
  </tr>
  <tr>
    <td> Age </td> <td> 24 </td>
  </tr>
  <tr>
    <td> Height </td> <td> 6' </td>
  </tr>
  <tr>
    <td>
      <table>
        <tr>
          <td> Nested </td>
          <td> tables </td>
        </tr>
        <tr>
          <td> are </td>
          <td> fun </td>
        </tr>
      </table>
    </td>
  </tr>
</table>

<i>Phrasal elements can't span
<b>more than
one line.</b></i>

</body>
</html>
++
----

Hello, my ''name'' is '''Jonas'''! I carry the <u>wind</u>. Thanks for ''all'' you've shown us...

 Stuff <tt id="goes" class="text">goes</tt> here
     and it's preformatted,
       m'kay?

Let's see how this paragraph was handled... Excellent! Now how about a link: Get [http://www.getfirefox.com Firefox] and free yourself from madness!

* frog 
** pacman frog 
**# mouth 
**# stomach 
* mouse 

[[Image:logo.gif]]

* 1 
** 1a
** 1b 
* 2 
** 2a 
**# fee
**# fie
**# foe 
**#* fum 
* e 
*: This is some fancy indented text
* 3 
*; Cookies
*: Delicious delicacies

: One 
:: Two 
::: Three   

; Gubaba 
: See Diberri 

= Heading One =

Content of section one.

== Heading ==

Section two content

=== Heading ===

Crazy section three!

  Superman is my favorite superhero.
    This is pre-
      ''formatted'' text.
        And you should be proud
    that it's working.

* Do you '''love''' me? 
* ''Do you love me?'' 
* '''''It's a'' boy!''' 

{|
|+ Stuff
|-
| Name
| David
|-
| Age
| 24
|-
| Height
| 6'
|-
|
{|
| Nested
| tables
|-
| are
| fun
|}
|}

''Phrasal elements can't span '''more than one line.'''''