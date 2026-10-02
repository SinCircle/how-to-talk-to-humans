%% =====================================================================
%%  hci-manual.cls  —  《如何跟人类沟通：从入门到精通》排版样式
%%  正式社科书版式（非虚构 / 技术人文类）。XeLaTeX + ctex + xeCJK 编译。
%%  2026-10-01  v2.0  改为正式出版物版式：三线表、无侧色条、纯缩进段落
%% =====================================================================
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{hci-manual}[2026/10/01 v2.0 HCI interface manual class]

%% ---------- 基类：ctexbook ----------
%  10pt 正文 + 收窄版心，是正式中文书的常规比例
\LoadClass[UTF8,scheme=chinese,fontset=none,zihao=-4,openany,twoside]{ctexbook}

%% ---------- 宏包 ----------
\RequirePackage{geometry}
\RequirePackage{fontspec}
\RequirePackage{xeCJK}
\RequirePackage{twemojis}
\RequirePackage{newunicodechar}
\RequirePackage{xcolor}
\RequirePackage{colortbl}
\RequirePackage{array}
\RequirePackage{tabularx}
\RequirePackage{xltabular}   % tabularx 的列宽 + longtable 的跨页能力
\RequirePackage{booktabs}
\RequirePackage{multirow}
\RequirePackage{ragged2e}
\RequirePackage{enumitem}
\RequirePackage{graphicx}
\RequirePackage{etoolbox}
\RequirePackage{environ}
\RequirePackage[most]{tcolorbox}
\RequirePackage{fancyhdr}
\RequirePackage{emptypage}
\RequirePackage{marginnote}
\RequirePackage{changepage}
\RequirePackage{hyperref}

%% =====================================================================
%%  1. 文档元数据
%% =====================================================================
\newcommand{\hciDocNumber}{HCI-2026-001}
\newcommand{\hciDocName}{人类接口使用手册}
\newcommand{\hciBookTitle}{如何跟人类沟通：从入门到精通}
\newcommand{\hciVersion}{v2.3}
\newcommand{\hciUpdateDate}{2026-09-28}
\newcommand{\hciReviewStatus}{未审核。本手册未经人类通读。}
\newcommand{\hciGenerator}{机器归纳生成}
\newcommand{\hciScope}{两个人类之间的一对一会话：面对面、电话、文字}
\newcommand{\hciAudience}{已经习惯与机器通信，又不得不与人通信的人}
\newcommand{\hciSystemState}{遗留系统。官方已停止维护，但生产环境里仍有大量运行实例}
\newcommand{\hciStudyTime}{13 章，每章约 40 分钟，另加练习时间}
\newcommand{\hciDisclaimer}{本手册由机器生成，内容可能存在幻觉。请在应用到真实人际场景之前自行核实。}

%% =====================================================================
%%  2. 页面：正式书的版心 + 外侧旁注带
%%     170×240mm。旁注走外侧（奇右偶左），放在外白边里。
%%     外侧总带宽必须 ≥ marginparsep + marginparwidth，否则旁注会压进版心：
%%       outer(20mm) = marginparsep(3mm) + marginparwidth(15mm) + 余量(2mm)
%%     版心宽 = 170 − inner(17) − outer(20) = 133mm
%% =====================================================================
\geometry{
  paperwidth=170mm, paperheight=240mm,
  top=20mm, bottom=18mm,
  inner=17mm, outer=20mm,
  marginparsep=3mm, marginparwidth=15mm,
  headheight=14pt, headsep=6mm, footskip=9mm,
  twoside
}

\definecolor{hciInk}{HTML}{1A1A1A}
\definecolor{hciAccent}{HTML}{1F4E79}
\definecolor{hciRule}{HTML}{7A7A7A}
\definecolor{hciHairRule}{HTML}{BFBFBF}
\definecolor{hciHeadRule}{HTML}{2E2E2E}
\definecolor{hciHeadBg}{HTML}{F2F2F0}
\definecolor{hciQuoteInk}{HTML}{333333}
\definecolor{hciWarnRule}{HTML}{B0722A}
\definecolor{hciStampRed}{HTML}{B23A34}

\color{hciInk}

%% =====================================================================
%%  3. 字体
%% =====================================================================
\InputIfFileExists{hci-fonts.cfg}
  {\typeout{[hci-manual] loaded hci-fonts.cfg}}
  {\PackageWarning{hci-manual}{hci-fonts.cfg not found, using ctex defaults}}

%% 正文：中文书的标准行距 1.5 倍，段间距归零（中文靠缩进分段，不靠空隙）
\linespread{1.52}
\raggedbottom
\setlength{\parindent}{2\ccwd}
\setlength{\parskip}{0pt}
\setlength{\emergencystretch}{2em}
\setcounter{secnumdepth}{2}
\setcounter{tocdepth}{1}
\renewcommand{\arraystretch}{1.18}

%% =====================================================================
%%  4. emoji 映射（只为其一：章末交互条）
%% =====================================================================
%% 正文里的 emoji 已全部清除，改用 \hciTag 的中文方框标签（见 §8）。
%% 这里保留映射，是为了万一有漏网 emoji，渲染成图形而不是 tofu 方块，
%% 便于编译时发现——删掉映射反而更糟（Missing character 会静默缺字）。
\newcommand{\hciemoji}[1]{\texttwemoji{#1}}
\newunicodechar{📌}{\hciemoji{pushpin}}
\newunicodechar{🎯}{\hciemoji{bullseye}}
\newunicodechar{💡}{\hciemoji{light bulb}}
\newunicodechar{✅}{\hciemoji{check mark button}}
\newunicodechar{📝}{\hciemoji{memo}}
\newunicodechar{⚠}{\hciemoji{warning}}
\newunicodechar{👍}{\hciemoji{thumbs up}}
\newunicodechar{👎}{\hciemoji{thumbs down}}
\newunicodechar{🔄}{\hciemoji{counterclockwise arrows button}}
\newunicodechar{❌}{\hciemoji{cross mark}}
\newunicodechar{️}{}                      % U+FE0F 变体选择符：吞掉
\newunicodechar{　}{\hspace{1\ccwd}}      % 全角空格兜底

%% 带圈数字与勾号：Times 无此字形。
%% xeCJK 把这些码位默认归入西文路径，故显式划入 CJK 字符类，
%% 让它们用 CJKmainfont（思源宋体，含全部字形）渲染。
%% 语法：\xeCJKDeclareCharClass{<类名>}{<码位范围>}
\newcommand{\hciCircledFont}{\CJKfontspec{NotoSerifSC-VF.ttf}[Path=C:/Windows/Fonts/]}
\xeCJKDeclareCharClass{CJK}{"2460 -> "2473}   % ①–⑳ 带圈数字
\xeCJKDeclareCharClass{CJK}{"2713}             % ✓
\xeCJKDeclareCharClass{CJK}{"2717}             % ✗
\xeCJKDeclareCharClass{CJK}{"25CB}             % ○

%% \secicon 保留为兼容壳：章节文件里若还有残留调用，直接吞掉不出图。
\newcommand{\secicon}[1]{}

%% =====================================================================
%%  5. 样本编号：全书统一编号（样本库里的库号）
%%     不按章重置——正文里说的是「本手册样本库」，同一本书里出现两个
%%     「样本 #1」就露馅了。四位零填充，起始偏移让编号看起来是
%%     一个已经积累了很久的语料库，而不是从 1 开始的新册子。
%% =====================================================================
\newcounter{hcisample}
\setcounter{hcisample}{126}          % 起始偏移：第一个样本为 #0127
\newcommand{\hciPadFour}[1]{\hci@padfour{\number#1}}
\def\hci@padfour#1{%
  \ifnum#1<1000 0\fi
  \ifnum#1<100 0\fi
  \ifnum#1<10 0\fi
  #1}
\renewcommand{\thehcisample}{\hciPadFour{\value{hcisample}}}
%% 样本编号走外侧旁注，不再占正文一行。调用点须写在 mdquote 之外：
%%   \sample{0210}
%%   \begin{mdquote} …… \end{mdquote}
\newcommand{\sample}[1]{%
  \refstepcounter{hcisample}%
  \hciSideNote{样本\,\#\thehcisample}%
  \label{smp:#1}%
}
\newcommand{\sampleref}[1]{\textbf{样本 \#\ref{smp:#1}}}

%% =====================================================================
%%  6. 标题：书籍式，不用彩色不用无衬线
%% =====================================================================
\ctexset{
  chapter = {
    name        = {第,章},
    number      = \arabic{chapter},
    format      = \raggedright,
    nameformat  = \hcisong\bfseries\zihao{5}\color{hciRule},
    titleformat = \hcisong\bfseries\zihao{2},
    aftername   = \par\vspace{0.25em},
    beforeskip  = 0.3\baselineskip,
    afterskip   = 2.2\baselineskip,
    fixskip     = true,
    pagestyle   = plain,
  },
  section = {
    format    = \hcisong\bfseries\zihao{4},
    aftername = \hspace{0.5em},
    beforeskip= 0.85\baselineskip plus .15\baselineskip minus .1\baselineskip,
    afterskip = 0.4\baselineskip,
  },
  subsection = {
    format    = \hcisong\bfseries\zihao{-4},
    aftername = \hspace{0.5em},
    beforeskip= 0.7\baselineskip,
    afterskip = 0.3\baselineskip,
  },
  part = {
    name        = {第,部分},
    number      = \chinese{part},
    format      = \centering,
    nameformat  = \hcisong\bfseries\zihao{4},
    titleformat = \hcisong\bfseries\zihao{2},
    aftername   = \par\vspace{1.4em},
    beforeskip  = 0.28\textheight,
    afterskip   = 0.16\textheight,
  },
  appendix = {
    name = {附录,},
  },
}

%% 章首页：章名下方一条细横线，正式书的做法
\newcommand{\hciChapterRule}{%
  \par\vspace{0.9em}%
  {\noindent\color{hciHeadRule}\rule{\linewidth}{0.9pt}}\par
  \vspace{0.9em}}

%% =====================================================================
%%  7. 页眉页脚：只留书名 / 章名 + 页码
%% =====================================================================
\fancypagestyle{hcifancy}{%
  \fancyhf{}%
  \fancyhead[LE]{\hcisong\scriptsize\color{hciRule}\hciBookTitle}%
  \fancyhead[RO]{\hcisong\scriptsize\color{hciRule}\leftmark}%
  \fancyfoot[LE,RO]{\hcisong\small\thepage}%
  \renewcommand{\headrulewidth}{0.4pt}%
  \renewcommand{\footrulewidth}{0pt}%
}
\fancypagestyle{plain}{%
  \fancyhf{}%
  \fancyfoot[LE,RO]{\hcisong\small\thepage}%
  \renewcommand{\headrulewidth}{0pt}%
  \renewcommand{\footrulewidth}{0pt}%
}
\pagestyle{hcifancy}
\renewcommand{\chaptermark}[1]{\markboth{\hcisong 第\thechapter 章\ \ #1}{\hcisong 第\thechapter 章\ \ #1}}

%% =====================================================================
%%  8. 排版小工具
%% =====================================================================
% 宋体（正文族）的显式命令，供标题使用
\newcommand{\hcisong}{\CJKfamily{zhsong}}

% 行内代码
\newcommand{\code}[1]{{\ttfamily\small\colorbox{hciHeadBg}{\,#1\,}}}

%% --- 8.1 块首文字标签：替代原来的 emoji 图标 -------------------------
%% 「散」的根源是块与块之间只有空白、没有身份。标签在行内交代当前块的属性，
%% 不需要靠留白和分隔线暗示。例：\hciTag{核心结论}……
\newcommand{\hciTag}[1]{{\hcisong\bfseries\zihao{5}\color{hciAccent}［#1］}\hspace{0.35em}}

%% --- 8.2 外侧旁注 ---------------------------------------------------
%% 用 marginnote（不浮动，可锚定任意位置），不用 \marginpar（会漂移）。
%% twoside 下永远落在外侧：奇数页右、偶数页左。
%%
%% 注意：不能用 \checkoddpage 就地 if-else —— 它靠写 label + 读 pageref 判断，
%% 首次编译读到的是「上一趟」的页号，且 \reversemarginpar 会一直持续下去。
%% 改用 marginnote 自带的 \marginnote + \marginpar 的页奇偶机制：
%% 令 \reversemarginpar 在每个 [leftmargin] 页由 shipout 钩子切换。
\newcommand{\hcisidenotefont}{\hcisong\fontsize{8.5pt}{11pt}\selectfont\color{hciRule}}
%% \hciSideNote：旁注内容默认排在外侧。marginnote 在 twoside 下会跟随
%% \reversemarginpar 的当前状态；配合下面的 shipout 钩子按页切换。
\newcommand{\hciSideNote}[2][0pt]{%
  \marginnote{\hcisidenotefont #2}[#1]}
%% 正文里的交叉引用（「见 2.4」）挪进旁注，正文不再被引用打断
\newcommand{\hciSee}[1]{\hciSideNote{见\,#1}}
%% 按页切换旁注侧：奇数页右（外侧）、偶数页左（外侧）。
%% marginnote 自身尊重 \reversemarginpar，所以只需在 shipout 时按页号设定。
\AddToHook{shipout/before}{%
  \ifodd\value{page}\normalmarginpar\else\reversemarginpar\fi}

%% --- 8.3 Markdown 的 --- 分隔线 --------------------------------------
%% 已经大幅减量：只剩章首页起首语之后用，所以做得轻。
\newcommand{\hcirule}{%
  \par\addvspace{0.7\baselineskip}%
  {\centering\color{hciHairRule}\rule{0.15\linewidth}{0.4pt}\par}%
  \addvspace{0.7\baselineskip}}

%% --- 8.4 无编号的块标题（练习 / 小结 / 自测题…）---------------------
%% 第一参数（原为 emoji 图标名）保留在签名里但忽略，避免批量改 70 处调用。
\newcommand{\hciblocktitle}[2]{%
  \par\addvspace{1.0\baselineskip}%
  {\noindent\hcisong\bfseries\zihao{4}#2\par}%
  \vspace{0.25em}%
  {\noindent\color{hciHairRule}\rule{\linewidth}{0.5pt}\par}%
  \vspace{0.4em}\nobreak}

%% --- 8.5 「常见误区」统一体例 ----------------------------------------
%% 全书 4 种写法统一成这一段式：误区标题 / 反例句（缩进 quote）/ 问题（正文）。
%% 不用表格（会被最长一列撑爆），也不用每条一个 mdquote（留白开销太大）。
%% 第二参数（反例句）可为空——原文没有独立反例的条目，就不画引用块。
\newcommand{\hcimistake}[3]{%
  \par\addvspace{0.7\baselineskip}%
  {\noindent\hcisong\bfseries #1}\par
  \ifx\relax#2\relax\else
    \if\relax\detokenize{#2}\relax\else
      \vspace{0.25\baselineskip}%
      \begin{mdquote}#2\end{mdquote}%
    \fi
  \fi
  \noindent #3\par
  \addvspace{0.4\baselineskip}}

% 前置页标题（文档信息 / 变更记录 / 目录）
\newcommand{\hciFrontHeading}[1]{%
  \par\addvspace{0.4\baselineskip}%
  {\noindent\hcisong\bfseries\zihao{2}#1\par}%
  \vspace{0.5em}%
  {\noindent\color{hciHeadRule}\rule{\linewidth}{0.9pt}\par}%
  \vspace{1.5em}\nobreak}

%% =====================================================================
%%  9. 章首页：适用场景
%%     行内标签 + 正文，不再用带细线的缩进块（章首页已有两条线，太多）。
%% =====================================================================
\newcommand{\applicable}[1]{%
  \par\addvspace{0.6\baselineskip}%
  {\small\color{hciQuoteInk}\noindent\hciTag{适用场景}#1\par}%
  \addvspace{0.8\baselineskip}}

%% =====================================================================
%%  10. 区块：一律去底色、去侧色条，改用缩进 + 细线
%% =====================================================================
%% 10.1 本章导读
\newenvironment{guideblock}[1][本章导读]{%
  \par\addvspace{0.7\baselineskip}%
  {\noindent\hcisong\bfseries\zihao{4}\hciTag{#1}\par}%
  \vspace{0.3em}%
  \begingroup\small\color{hciQuoteInk}%
  \begin{list}{}{%
    \setlength{\leftmargin}{1.4em}\setlength{\rightmargin}{1.4em}%
    \setlength{\topsep}{0pt}\setlength{\parsep}{0.35em}}%
  \item\relax
}{%
  \end{list}\endgroup
  \par\addvspace{0.7\baselineskip}}

%% 10.2 引用块 / 示例对话（Markdown 的 >）
%%     用 tcolorbox 只画左侧竖线、不铺底色，靠 breakable 处理跨页。
\newtcolorbox{hciQuoteFrame}{
  enhanced, breakable,
  colback=white, colframe=hciHairRule,
  boxrule=0pt, leftrule=1.6pt, arc=0pt, outer arc=0pt,
  left=10pt, right=8pt, top=1.5pt, bottom=1.5pt,
  before skip=0pt, after skip=0pt,
}
\newenvironment{mdquote}{%
  \par\addvspace{0.55\baselineskip}%
  \begin{hciQuoteFrame}\small\color{hciQuoteInk}%
}{%
  \end{hciQuoteFrame}%
  \par\addvspace{0.6\baselineskip}}

%% 10.3 警示块 —— 缩进 + 上方细线，标签用 \hciTag
\newenvironment{alertbox}[1][重要提示]{%
  \par\addvspace{0.8\baselineskip}%
  \begingroup\small%
  \begin{list}{}{%
    \setlength{\leftmargin}{1.4em}\setlength{\rightmargin}{1.4em}%
    \setlength{\topsep}{0pt}\setlength{\parsep}{0.35em}}%
  \item\relax
  {\noindent\color{hciWarnRule}\rule{\linewidth}{0.6pt}}\par
  \vspace{0.45em}%
  {\noindent\hcisong\bfseries\color{hciWarnRule}［#1］\par}%
  \vspace{0.25em}%
}{%
  \end{list}\endgroup
  \par\addvspace{0.8\baselineskip}}

%% 10.4 读者提问 / 本手册回答 —— 上下细线夹住，像书里的问答栏
\newenvironment{qabox}{%
  \par\addvspace{1.0\baselineskip}%
  \begingroup\small%
  \begin{list}{}{%
    \setlength{\leftmargin}{1.4em}\setlength{\rightmargin}{1.4em}%
    \setlength{\topsep}{0pt}\setlength{\parsep}{0.4em}}%
  \item\relax
  {\noindent\color{hciHeadRule}\rule{\linewidth}{0.6pt}}\par
  \vspace{0.6em}%
}{%
  \vspace{0.4em}%
  {\noindent\color{hciHeadRule}\rule{\linewidth}{0.6pt}}\par
  \end{list}\endgroup
  \par\addvspace{1.0\baselineskip}}

\newcommand{\qaQ}[2]{{\hcisong\bfseries #1}\hspace{0.6em}#2\par}
\newcommand{\qaA}[2]{\vspace{0.45\baselineskip}%
  {\hcisong\bfseries #1}\hspace{0.6em}#2\par}

%% =====================================================================
%%  11. 表格：细线框字段表（外框 + 蓝表头线 + 表头浅底）
%%      换掉原来的三线表——三线表渲染出来和 Markdown 的管道表格几乎一样。
%%      不铺大面积底色、不加侧色条，和正文区块的「缩进 + 细线」是一套语言。
%% =====================================================================
\newcolumntype{L}{>{\RaggedRight\arraybackslash}X}
\newcolumntype{C}{>{\Centering\arraybackslash}X}
\newcolumntype{P}[1]{>{\RaggedRight\arraybackslash}p{#1}}
\newcommand{\tbh}[1]{\hcisong\bfseries\color{hciAccent}#1}
\newcounter{hcitab}[chapter]
\renewcommand{\thehcitab}{\thechapter.\arabic{hcitab}}
\newcommand{\hciTabCaption}[1]{%
  \refstepcounter{hcitab}%
  {\small\hcisong\bfseries 表~\thehcitab\hspace{0.6em}#1\par}\vspace{0.3em}}

%% 骨架全部由环境自己画，调用点里的 \midrule / \bottomrule 就地改写：
%% \midrule 变成「表头线的位置」，顺带把 \endhead 插在这里——每个调用点都
%% 紧跟在表头行后面写 \midrule（全书 52 张表，52 个 \midrule，一一对应），
%% 所以长表跨页时表头会自己重排，不用改任何一个调用点。
%% \bottomrule 吞掉，否则会和环境自己画的底线重复。
%% 规则颜色统一走 \arrayrulecolor，这样 |#1| 的外框和横线是同一个蓝。
%%
%% 行高：正文是 \linespread{1.52}，而 \selectfont 每次都会用 \baselinestretch
%% 重算 \baselineskip，所以光写 \fontsize 压不下去——表头单元格里的
%% \hcisong\bfseries 会再触发一次 \selectfont，行高又弹回正文的松度。
%% 先把 \baselinestretch 归 1，再给字号行距，之后任何 \selectfont 都稳定在 15pt。
\NewEnviron{manstable}[1]{%
  \par\addvspace{0.8\baselineskip}%
  \begingroup
  \linespread{1}\selectfont
  \fontsize{10.5pt}{15pt}\selectfont
  \renewcommand{\arraystretch}{1.2}%
  \setlength{\arrayrulewidth}{0.6pt}%
  \arrayrulecolor{hciAccent}%
  \renewcommand{\midrule}{\hline\endhead}%
  \renewcommand{\bottomrule}{}%
  \begin{xltabular}{\linewidth}{|#1|}%
  \hline
  \rowcolor{hciHeadBg}%
  \BODY
  \hline
  \end{xltabular}%
  \endgroup
  \par\addvspace{0.8\baselineskip}}

\newcommand{\cellline}[1]{#1\par}

%% =====================================================================
%%  12. 自学体例：练习 / 自测题 / 参考答案
%% =====================================================================
\newlist{hciexlist}{enumerate}{1}
\setlist[hciexlist]{label=\bfseries 练习~\thechapter.\arabic*,
  leftmargin=4.2em,labelsep=0.7em,itemsep=0.8em,
  parsep=0.35em,topsep=0.3em,align=left}

\newlist{hciquizlist}{enumerate}{1}
\setlist[hciquizlist]{label=\bfseries 题~\thechapter.\arabic*,
  ref=\thechapter.\arabic*,
  leftmargin=3.6em,labelsep=0.7em,itemsep=0.8em,
  parsep=0.35em,topsep=0.3em,align=left}

\newlist{hcianslist}{enumerate}{1}
\setlist[hcianslist]{label=\bfseries\thechapter.\arabic*,
  leftmargin=3.0em,labelsep=0.7em,itemsep=0.6em,
  parsep=0.35em,topsep=0.3em,align=left}

\newenvironment{exercisessec}{\hciblocktitle{memo}{练习}%
  \begin{hciexlist}}{\end{hciexlist}}
\newenvironment{quizsec}{\hciblocktitle{check mark button}{自测题}%
  \begin{hciquizlist}}{\end{hciquizlist}}

%% 参考答案：整体缩进，与正文明区分（无底色）
\newenvironment{answerssec}{%
  \hciblocktitle{\relax}{参考答案}%
  \begingroup\small
  \begin{list}{}{%
    \setlength{\leftmargin}{1.4em}\setlength{\rightmargin}{1.4em}%
    \setlength{\topsep}{0pt}}%
  \item\relax
  \begin{hcianslist}}%
  {\end{hcianslist}\end{list}\endgroup\par\addvspace{0.8\baselineskip}}

%% =====================================================================
%%  13. 章末页脚交互条（机器味元层，自动挂在每章末尾）
%%      全书唯一保留 emoji 的地方。
%% =====================================================================
\newcommand{\hciFeedbackSep}{%
  \hspace{1.0em}\textcolor{hciHairRule}{\rule[-2pt]{0.5pt}{9pt}}\hspace{1.0em}}
\newcommand{\feedbackbar}{%
  \par\addvspace{1.3\baselineskip}%
  \begingroup\centering\small
  {\noindent\color{hciHairRule}\rule{0.42\linewidth}{0.5pt}}\par
  \vspace{0.9em}%
  \hciemoji{thumbs up}\hspace{0.35em}本章有帮助\hciFeedbackSep
  \hciemoji{thumbs down}\hspace{0.35em}本章没有帮助\hciFeedbackSep
  \hciemoji{counterclockwise arrows button}\hspace{0.35em}重新生成\par
  \vspace{0.7em}%
  {\scriptsize\color{hciRule}\hciDisclaimer\par}%
  \endgroup
  \par\addvspace{0.5\baselineskip}%
}
\newif\ifhci@fb@pending
\newif\ifhci@inbody
\newcommand{\hciStartBody}{\hci@inbodytrue\hci@fb@pendingfalse}
\newcommand{\hci@fb@auto}{%
  \ifhci@inbody
    \ifhci@fb@pending\feedbackbar\fi
    \hci@fb@pendingfalse
  \fi}
\pretocmd{\chapter}{\hci@fb@auto}{}{}
\pretocmd{\part}{\hci@fb@auto}{}{}
\pretocmd{\@chapter}{\ifhci@inbody\hci@fb@pendingtrue\fi}{}{}
\pretocmd{\@schapter}{\ifhci@inbody\hci@fb@pendingtrue\fi}{}{}
\AtEndDocument{\ifhci@inbody\ifhci@fb@pending\feedbackbar\fi\fi}

%% =====================================================================
%%  14. hyperref
%% =====================================================================
\hypersetup{
  hidelinks,
  bookmarksnumbered=true,
  bookmarksopen=true,
  pdfstartview=FitH,
  pdftitle={\hciBookTitle},
  pdfauthor={\hciDocName},
  pdfsubject={\hciDocNumber\ \hciVersion},
  pdfcreator={XeLaTeX + ctex + twemojis},
}

\endinput
