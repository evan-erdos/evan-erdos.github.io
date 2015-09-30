---
layout: bare
title: Chess
permalink: /chess/
---

<script src="/js/2kchess.js"></script>


</script>

<style>


body { overflow: hidden; }

p span { white-space:nowrap }
a { color:#385bc2; text-decoration:none }
a:hover { color:#b53b3b }

table { width: 100% }
td {
	min-width: 1em;
	width: 1em;
	max-width: 1em;
	min-height: 1em;
	height: 1em;
	max-height: 1em;
	overflow:hidden;
	font:3em/1 "MS Gothic","Segoe UI Symbol","DejaVu Sans";
	color: white;
	text-shadow: 0px 0px 2px #ffffff;
	background: url("/rsc/tech.png");
	background-repeat: repeat-x repeat-y;
	background-size: cover;
	background-position: center;
	text-align:center;
}

tr:nth-child(odd) td:nth-child(even), tr:nth-child(even) td:nth-child(odd) { background: url("/rsc/dark-tex.png");
}

table { margin-top:.25em }
td { font-size:4em; cursor:pointer }
td[lang='0'] { outline:thin solid #a00; color:#800 }

@media (max-width:40em) {
   body { width:100% }
   p#menu small { display:none }
   div#info { margin-left:.5em; margin-right:.5em }
}
</style>



<table>
<tr><td onclick="V(21)" id="21">♜<td onclick="V(22)" id="22">♞<td onclick="V(23)" id="23">♝<td onclick="V(24)" id="24">♛<td onclick="V(25)" id="25">♚<td onclick="V(26)" id="26">♝<td onclick="V(27)" id="27">♞<td onclick="V(28)" id="28">♜<tr><td onclick="V(31)" id="31">♟<td onclick="V(32)" id="32">♟<td onclick="V(33)" id="33">♟<td onclick="V(34)" id="34">♟<td onclick="V(35)" id="35">♟<td onclick="V(36)" id="36">♟<td onclick="V(37)" id="37">♟<td onclick="V(38)" id="38">♟<tr><td onclick="V(41)" id="41"><td onclick="V(42)" id="42"><td onclick="V(43)" id="43"><td onclick="V(44)" id="44"><td onclick="V(45)" id="45"><td onclick="V(46)" id="46"><td onclick="V(47)" id="47"><td onclick="V(48)" id="48"><tr><td onclick="V(51)" id="51"><td onclick="V(52)" id="52"><td onclick="V(53)" id="53"><td onclick="V(54)" id="54"><td onclick="V(55)" id="55"><td onclick="V(56)" id="56"><td onclick="V(57)" id="57"><td onclick="V(58)" id="58"><tr><td onclick="V(61)" id="61"><td onclick="V(62)" id="62"><td onclick="V(63)" id="63"><td onclick="V(64)" id="64"><td onclick="V(65)" id="65"><td onclick="V(66)" id="66"><td onclick="V(67)" id="67"><td onclick="V(68)" id="68"><tr><td onclick="V(71)" id="71"><td onclick="V(72)" id="72"><td onclick="V(73)" id="73"><td onclick="V(74)" id="74"><td onclick="V(75)" id="75"><td onclick="V(76)" id="76"><td onclick="V(77)" id="77"><td onclick="V(78)" id="78"><tr><td onclick="V(81)" id="81">♙<td onclick="V(82)" id="82">♙<td onclick="V(83)" id="83">♙<td onclick="V(84)" id="84">♙<td onclick="V(85)" id="85">♙<td onclick="V(86)" id="86">♙<td onclick="V(87)" id="87">♙<td onclick="V(88)" id="88">♙<tr><td onclick="V(91)" id="91">♖<td onclick="V(92)" id="92">♘<td onclick="V(93)" id="93">♗<td onclick="V(94)" id="94">♕<td onclick="V(95)" id="95">♔<td onclick="V(96)" id="96">♗<td onclick="V(97)" id="97">♘<td onclick="V(98)" id="98">♖</table>