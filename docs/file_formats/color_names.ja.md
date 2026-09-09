# 色の名前

出せる色は 256 色です。赤 3 ビット、緑 3 ビット、青 2 ビットを 1 バイトに詰めた
形 (RGB332) で、色を指定するところではこのバイトをそのまま書けます (`0x1F` など)。ただ、
ほとんどの色には名前も付いています。人が編集するファイルを人が読める状態に保つのは、
名前の方です。

名前は web のもので、本体が出せる 256 色に対応づけてあります。対応づけると重なる名前が
出るので (3-3-2 の格子では ivory と snow を区別できません)、一覧は 2 つに分かれています。
異なる色に 1 つずつ付いた 78 個と、すでに一覧にある色に重なる 23 個です。どちらも受け付け
ますが、選択画面が示すのも、ファイルに書かれるのも 78 個の方です。

## 78 個

見本の色は、本体が展開したとおりの色です。ここで大まかに見える色は、画面でも同じように
見えます。

<div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(148px,1fr));gap:.4rem .8rem;margin:1rem 0">
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#000000"></span><span><code>black</code><br><small>0x00</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#FFFFFF"></span><span><code>white</code><br><small>0xFF</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#FF0000"></span><span><code>red</code><br><small>0xE0</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#00FF00"></span><span><code>lime</code><br><small>0x1C</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#0000FF"></span><span><code>blue</code><br><small>0x03</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#FFFF00"></span><span><code>yellow</code><br><small>0xFC</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#00FFFF"></span><span><code>cyan</code><br><small>0x1F</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#FF00FF"></span><span><code>magenta</code><br><small>0xE3</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#B6B6AA"></span><span><code>silver</code><br><small>0xB6</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#9191AA"></span><span><code>gray</code><br><small>0x92</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#910000"></span><span><code>maroon</code><br><small>0x80</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#919100"></span><span><code>olive</code><br><small>0x90</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#009100"></span><span><code>green</code><br><small>0x10</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#9100AA"></span><span><code>purple</code><br><small>0x82</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#0091AA"></span><span><code>teal</code><br><small>0x12</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#0000AA"></span><span><code>navy</code><br><small>0x02</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#FFB600"></span><span><code>orange</code><br><small>0xF4</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#FFDA00"></span><span><code>gold</code><br><small>0xF8</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#FFB6AA"></span><span><code>pink</code><br><small>0xF6</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#FF6DAA"></span><span><code>hotpink</code><br><small>0xEE</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#FF24AA"></span><span><code>deeppink</code><br><small>0xE6</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#DA2455"></span><span><code>crimson</code><br><small>0xC5</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#B62400"></span><span><code>firebrick</code><br><small>0xA4</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#FF6D55"></span><span><code>tomato</code><br><small>0xED</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#FF9155"></span><span><code>salmon</code><br><small>0xF1</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#FF4800"></span><span><code>orangered</code><br><small>0xE8</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#FF9100"></span><span><code>darkorange</code><br><small>0xF0</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#FFDAAA"></span><span><code>khaki</code><br><small>0xFA</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#DAB6AA"></span><span><code>tan</code><br><small>0xD6</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#DA9155"></span><span><code>peru</code><br><small>0xD1</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#DA6D00"></span><span><code>chocolate</code><br><small>0xCC</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#914800"></span><span><code>saddlebrown</code><br><small>0x88</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#914855"></span><span><code>sienna</code><br><small>0x89</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#B6B655"></span><span><code>darkkhaki</code><br><small>0xB5</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#91DA55"></span><span><code>yellowgreen</code><br><small>0x99</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#6D9100"></span><span><code>olivedrab</code><br><small>0x70</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#B6FF55"></span><span><code>greenyellow</code><br><small>0xBD</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#6DFF00"></span><span><code>chartreuse</code><br><small>0x7C</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#00FF55"></span><span><code>springgreen</code><br><small>0x1D</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#24DA55"></span><span><code>limegreen</code><br><small>0x39</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#249100"></span><span><code>forestgreen</code><br><small>0x30</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#006D00"></span><span><code>darkgreen</code><br><small>0x0C</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#249155"></span><span><code>seagreen</code><br><small>0x31</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#48B655"></span><span><code>mediumseagreen</code><br><small>0x55</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#91FFAA"></span><span><code>lightgreen</code><br><small>0x9E</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#91B6AA"></span><span><code>darkseagreen</code><br><small>0x96</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#6DFFAA"></span><span><code>aquamarine</code><br><small>0x7E</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#48DAAA"></span><span><code>turquoise</code><br><small>0x5A</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#00DAAA"></span><span><code>darkturquoise</code><br><small>0x1A</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#24B6AA"></span><span><code>lightseagreen</code><br><small>0x36</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#DAFFFF"></span><span><code>lightcyan</code><br><small>0xDF</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#B6FFFF"></span><span><code>paleturquoise</code><br><small>0xBF</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#B6DAFF"></span><span><code>powderblue</code><br><small>0xBB</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#91DAFF"></span><span><code>skyblue</code><br><small>0x9B</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#00B6FF"></span><span><code>deepskyblue</code><br><small>0x17</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#2491FF"></span><span><code>dodgerblue</code><br><small>0x33</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#6D91FF"></span><span><code>cornflowerblue</code><br><small>0x73</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#4891AA"></span><span><code>steelblue</code><br><small>0x52</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#486DFF"></span><span><code>royalblue</code><br><small>0x4F</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#242455"></span><span><code>midnightblue</code><br><small>0x25</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#6D48AA"></span><span><code>slateblue</code><br><small>0x6A</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#916DFF"></span><span><code>mediumpurple</code><br><small>0x8F</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#9124FF"></span><span><code>blueviolet</code><br><small>0x87</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#9124AA"></span><span><code>darkorchid</code><br><small>0x86</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#B648AA"></span><span><code>mediumorchid</code><br><small>0xAA</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#DA6DFF"></span><span><code>orchid</code><br><small>0xCF</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#FF91FF"></span><span><code>violet</code><br><small>0xF3</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#DA91FF"></span><span><code>plum</code><br><small>0xD3</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#DAB6FF"></span><span><code>thistle</code><br><small>0xD7</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#DADAFF"></span><span><code>lavender</code><br><small>0xDB</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#4800AA"></span><span><code>indigo</code><br><small>0x42</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#B624AA"></span><span><code>mediumvioletred</code><br><small>0xA6</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#DA6DAA"></span><span><code>palevioletred</code><br><small>0xCE</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#FFDAFF"></span><span><code>mistyrose</code><br><small>0xFB</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#DADAAA"></span><span><code>lightgray</code><br><small>0xDA</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#6D6D55"></span><span><code>dimgray</code><br><small>0x6D</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#6D91AA"></span><span><code>lightslategray</code><br><small>0x72</small></span></div>
<div style="display:flex;align-items:center;gap:.5rem"><span style="width:20px;height:20px;flex:none;border-radius:3px;border:1px solid rgba(128,128,128,.6);background:#244855"></span><span><code>darkslategray</code><br><small>0x29</small></span></div>
</div>

## これも受け付けます

ファイルに書いても、シェルで打っても通ります。解決する先は右の色です。名前を聞き返すと、
そちらの名前が返ります。

| 受け付ける名前 | 同じ色になるもの | |
|---|---|---|
| `darkred` | `maroon` | <span style="display:inline-block;width:14px;height:14px;vertical-align:-2px;border-radius:2px;border:1px solid rgba(128,128,128,.6);background:#910000"></span> 0x80 |
| `coral` | `tomato` | <span style="display:inline-block;width:14px;height:14px;vertical-align:-2px;border-radius:2px;border:1px solid rgba(128,128,128,.6);background:#FF6D55"></span> 0xED |
| `lightyellow` | `white` | <span style="display:inline-block;width:14px;height:14px;vertical-align:-2px;border-radius:2px;border:1px solid rgba(128,128,128,.6);background:#FFFFFF"></span> 0xFF |
| `ivory` | `white` | <span style="display:inline-block;width:14px;height:14px;vertical-align:-2px;border-radius:2px;border:1px solid rgba(128,128,128,.6);background:#FFFFFF"></span> 0xFF |
| `beige` | `white` | <span style="display:inline-block;width:14px;height:14px;vertical-align:-2px;border-radius:2px;border:1px solid rgba(128,128,128,.6);background:#FFFFFF"></span> 0xFF |
| `wheat` | `khaki` | <span style="display:inline-block;width:14px;height:14px;vertical-align:-2px;border-radius:2px;border:1px solid rgba(128,128,128,.6);background:#FFDAAA"></span> 0xFA |
| `brown` | `firebrick` | <span style="display:inline-block;width:14px;height:14px;vertical-align:-2px;border-radius:2px;border:1px solid rgba(128,128,128,.6);background:#B62400"></span> 0xA4 |
| `lawngreen` | `chartreuse` | <span style="display:inline-block;width:14px;height:14px;vertical-align:-2px;border-radius:2px;border:1px solid rgba(128,128,128,.6);background:#6DFF00"></span> 0x7C |
| `palegreen` | `lightgreen` | <span style="display:inline-block;width:14px;height:14px;vertical-align:-2px;border-radius:2px;border:1px solid rgba(128,128,128,.6);background:#91FFAA"></span> 0x9E |
| `darkcyan` | `teal` | <span style="display:inline-block;width:14px;height:14px;vertical-align:-2px;border-radius:2px;border:1px solid rgba(128,128,128,.6);background:#0091AA"></span> 0x12 |
| `mediumblue` | `navy` | <span style="display:inline-block;width:14px;height:14px;vertical-align:-2px;border-radius:2px;border:1px solid rgba(128,128,128,.6);background:#0000AA"></span> 0x02 |
| `darkblue` | `navy` | <span style="display:inline-block;width:14px;height:14px;vertical-align:-2px;border-radius:2px;border:1px solid rgba(128,128,128,.6);background:#0000AA"></span> 0x02 |
| `darkviolet` | `purple` | <span style="display:inline-block;width:14px;height:14px;vertical-align:-2px;border-radius:2px;border:1px solid rgba(128,128,128,.6);background:#9100AA"></span> 0x82 |
| `darkmagenta` | `purple` | <span style="display:inline-block;width:14px;height:14px;vertical-align:-2px;border-radius:2px;border:1px solid rgba(128,128,128,.6);background:#9100AA"></span> 0x82 |
| `lightpink` | `pink` | <span style="display:inline-block;width:14px;height:14px;vertical-align:-2px;border-radius:2px;border:1px solid rgba(128,128,128,.6);background:#FFB6AA"></span> 0xF6 |
| `darkgray` | `silver` | <span style="display:inline-block;width:14px;height:14px;vertical-align:-2px;border-radius:2px;border:1px solid rgba(128,128,128,.6);background:#B6B6AA"></span> 0xB6 |
| `slategray` | `lightslategray` | <span style="display:inline-block;width:14px;height:14px;vertical-align:-2px;border-radius:2px;border:1px solid rgba(128,128,128,.6);background:#6D91AA"></span> 0x72 |
| `gainsboro` | `lavender` | <span style="display:inline-block;width:14px;height:14px;vertical-align:-2px;border-radius:2px;border:1px solid rgba(128,128,128,.6);background:#DADAFF"></span> 0xDB |
| `whitesmoke` | `white` | <span style="display:inline-block;width:14px;height:14px;vertical-align:-2px;border-radius:2px;border:1px solid rgba(128,128,128,.6);background:#FFFFFF"></span> 0xFF |
| `snow` | `white` | <span style="display:inline-block;width:14px;height:14px;vertical-align:-2px;border-radius:2px;border:1px solid rgba(128,128,128,.6);background:#FFFFFF"></span> 0xFF |
| `azure` | `white` | <span style="display:inline-block;width:14px;height:14px;vertical-align:-2px;border-radius:2px;border:1px solid rgba(128,128,128,.6);background:#FFFFFF"></span> 0xFF |
| `honeydew` | `white` | <span style="display:inline-block;width:14px;height:14px;vertical-align:-2px;border-radius:2px;border:1px solid rgba(128,128,128,.6);background:#FFFFFF"></span> 0xFF |
| `linen` | `white` | <span style="display:inline-block;width:14px;height:14px;vertical-align:-2px;border-radius:2px;border:1px solid rgba(128,128,128,.6);background:#FFFFFF"></span> 0xFF |

## 名前が使える場所

| | |
|---|---|
| [`/home/colors.toml`](colors.md) | `bg = "midnightblue"` |
| シェルの `color` コマンド | `color bg skyblue`。`color names` で 78 個を並べます |
| エディタの Colors ダイアログ | 書き込む先は同じファイルです |
| アプリから (`FmrbColors`) | 下記 |

## アプリから (`FmrbColors`)

| メソッド | |
|---|---|
| `FmrbColors.by_name("skyblue")` | 値。こちらの名前でなければ `nil` |
| `FmrbColors.to_color(str)` | 同じですが、`"0x1F"` や `"31"` も受け付けます |
| `FmrbColors.to_text(value)` | その名前。無ければ `"0x1F"` の形。ファイルに書かれるのはこれです |
| `FmrbColors.name_of(value)` | その名前、無ければ `nil` |
| `FmrbColors.palette_size` / `name_at(i)` / `palette_value(i)` | 78 個を順に見る。選択画面はこれで作ります |
| `FmrbColors.shade(色, avoid = nil)` | 一段暗い色。暗くすると `avoid` や元の色と同じになるときは明るい方へ。エディタの 2 本のバーはこれで作っています |
| `FmrbColors.section("editor")` | 利用者の配色ファイルのその節を Hash で |

こちらの名前でないものは、色ではなく `nil` になります。これは意図的です。配色ファイルの
打ち間違いで、アプリが真っ黒に塗られるのではなく、テーマの色がそのまま残ります。

## 関連

- [配色 (`colors.toml`)](colors.md) — アプリの色を上書きする
- [システム設定](system_conf.md#theme) — システムのテーマの 9 色
- [描画](../api/fmrb_gfx.md#色) — `FmrbGfx` 自身の色定数と RGB332
