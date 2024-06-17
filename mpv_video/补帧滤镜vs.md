**使用的机翻，我没精力个人翻译这么多，有问题的直接看英文**


## 介绍

SVP同时使用中央处理器（CPU）和图形处理器（GPU）。由于实现的特点，CPU承担大多数的负载，而且视频的帧尺寸越大，就需要越大的CPU功率。

## 软件需求


mpv播放器以及SVPtube模块至少需要Windows 7。

Apple macOS 10.11 “El Capitan”或更高。

## 使用建议

Full HD (1080p)：Intel Core i5 (4 内核)，AMD Ryzen 3，AMD FX (6 内核)

Ultra HD (4K, 2160p)：Intel Core i7 (6 内核)，AMD Ryzen 7 (8 内核)

## 粗略查看

* 渲染选项——这一组的选项影响到根据已求得的运动矢量的创建插值帧的过程。这项操作的大部分是由GPU执行的，并不影响CPU的负载。
	* 帧插补模式——这种选项定义原来帧数和插值帧数的比值。插值帧的数量越少，平滑度越低，不过，失真的数量也减少。
	* “2m”(伪影最少)——是最小插值帧的数量。比如说，如果帧速率增长2.5倍 ，每一个原来帧能重复两次。
	* “1m”(普通模式)——每一个原来帧能使用一次。
	* “1.5m”(少量伪影)——跟1m模式一样，但插值帧的时间更接近于原来帧的时间，失真的可见性会降低。
	* 恒定帧间隔 (最流畅)——均匀插值提供最大可能的平滑度，但在某些情况下（如提高帧率的系数是非线性的），这导致大多数帧会被插值。
	* 自适应——根据求得的运动矢量的质量，模式被自动选择。在难于分析的场景中，平滑度能降低。
* SVP着色器——计算插值帧的算法，其使用两个或更多个原来帧和求得的运动矢量，
	1. 最快 (适用于慢电脑)——最快的算法，它对于具有慢的CPU或没有GPU的系统很有用。
	2. 锐利 (适用于动画)——这个算法提高清晰图像，因为它不能把相邻两帧混合在一起。建议使用它观看手动动画片。
	11. 简单清淡——基于运动，这个算法进行简单的帧融合。
	10. 分块 (仅使用 CPU)——进行简单帧融合的算法，它利用图像的块来进行运动插值。在不用GPU的情况下，这种算法比其他任何算法执行得更快。
	21. 简单——这个算法进行简单的帧融合并添加掩模，其掩模可帮助减少出现在运动物体周围和在帧边界上的光晕的数量。
	13. 标准——第十一个算法的一种变体，但这种算法没有掩模功能，不过，随失真的可见性提高，它也可以提供更大的平滑度。
	23. 复杂——这种算法使用最复杂的掩模。
* 伪影去除力度——额外的掩模，它修正可能出现在具有不可靠的运动矢量的帧区域中的失真。可以用一些有一定透明度的原来帧的部分覆盖这种区域。掩模越强，图像越模糊并平滑度越低。
	* 禁用——掩模是被禁用的；
	* 最轻微，轻微——使用最佳值；
	* 中等——可导致出现一些特定的失真，如三倍轮廓；
	* 强, 最强——使用最大值，但不建议您使用它。
* 运动向量选项——搜索运动矢量的选项。这一组的所有参数都会显著影响CPU负载。
	* 运动向量精度——搜索运动矢量的精度提高能增加慢运动的平滑度（如在黑色背景上显示的电影片尾字幕）。高精度显著增加内存的使用，特别是系统不用GPU。比如说，为观看Ultra HD视频时提供高精度，可能要求使用超过5GB的内存。
	* 运动向量网格——搜索运动矢量的算法，它采用视频帧的小块来操作。帧块越小，越有可能您会在帧中找到小物体的运动，并越多波动失真在物体轮廓上能被可见。
	* 减小网格步长——额外的细化运动矢量，同时把帧块减少一半。
	* 搜索半径——搜索运动矢量的范围，它限制最大的矢量长和图像的“流动程度”。搜索范围越大，越有可能得出错误的运动矢量，从而会导致出现更多的插值失真。
		* 小并且快速——禁用用于比较帧块的耗资密集的SADT功能；
		* 小、中等、大。
	* 宽范围搜索力度——如果普通的搜索不能提供良好的效果，可以用更大的范围再试求得运动矢量。
	* 粗等级处理的最大宽度——在运动矢量的分层搜索中，在不同层次上都要使用不同的搜索参数；在最后一些层次上，使用的是更大的搜索范围，所以更简单的参数用于减少CPU的负载。这个价值越小，越多最后的层次将使用更简单的参数。
* 其他选项
	* 场景变换处理——一种制造中间帧的方法在切换场景时（就是没有运动矢量的时候）：
		* 混合相邻帧——通过简单混合两个帧而实现在两个场景之间平滑的切换；
		* 帧重复——通过原来帧的回放而实现瞬间场景切换。
	* 渲染设备——在此设定档中可以使用不同于在主菜单中指定的GPU设备。
	* 处理线程——对主菜单中指定的“处理线程”价值的补充。计算线程的数量直接影响内存使用量。

## 精准调整


1. **Rendering options** – options of this group affect the creation of an interpolated frame based on the already deduced motion vectors ("**motion compensation**"). Most of this work is performed on GPU and does not affect the CPU load.  
    渲染选项 – 此组的选项会影响基于已推导的运动矢量（“运动补偿”）创建插值帧。大部分工作是在 GPU 上执行的，不会影响 CPU 负载。
    - **Frames interpolation mode** – defines the ratio of the number of source frames to the number of interpolated frames. The lower the number of interpolated frames are inserted, the lower the smoothness is, but also the lower number of artifacts are introduced.  
        帧插值模式 – 定义源帧数与插值帧数的比率。插入的插值帧数越少，平滑度越低，但引入的伪影数量也越少。
        - **2m (min artifacts)** – the minimum number of interpolated frames. For example, if the frame rate is increased up to 2.5 of the original rate, each original frame is repeated twice.  
            2m （min artifacts） – 插值帧的最小数量。例如，如果帧速率增加到原始速率的 2.5，则每个原始帧将重复两次。
        - **1m (average mode)** – each original frame is used once.  
            1m（平均模式）——每个原始帧使用一次。
        - **1.5m (less artifacts)** – similar to the 1m mode, but the interpolated frames are closer in time to the original frames, which reduces the visibility of artifacts.  
            1.5m（伪像较少）——类似于 1m 模式，但插值帧在时间上更接近原始帧，从而降低了伪像的可见性。
        - **Uniform (max fluidity)** – uniform interpolation gives the greatest possible smoothness, but in some cases (a non-integer coefficient for increasing the frame rate) results in most frames being interpolated thus increases artifacts visibility.  
            均匀（最大流动性）——均匀插值可提供最大的平滑度，但在某些情况下（用于提高帧速率的非整数系数）会导致大多数帧值，从而增加伪影的可见性。
        - **Adaptive** – automatic mode selection for every frame, depending on the quality of the deduced motion vectors. In the scenes, which are difficult to analyze, the smoothness will decrease.  
            自适应 – 根据推断的运动矢量的质量，自动选择每一帧的模式。在难以分析的场景中，流畅度会下降。
    - **SVP shader** – an algorithm for interpolated frame calculation that uses two or more source frames and the deduced motion vectors:  
        SVP 着色器 – 一种用于插值帧计算的算法，它使用两个或多个源帧和推导的运动矢量：
        - **1. Fastest (slow PCs)** – the fastest algorithm that is useful for systems with slow CPU and without GPU.  
            1. 最快（慢速 PC） – 最快的算法，对 CPU 速度慢且没有 GPU 的系统很有用。
        - **2. Sharp (anime)** – this algorithm gives sharp images, because it does not blend neighboring frames; recommended for hand-drawn animation.  
            2. 锐利（动漫）——这种算法给出清晰的图像，因为它不混合相邻的帧;推荐用于手绘动画。
        - **11. Simple Lite** – an algorithm with simple blending of frames based on the motion.  
            11. Simple Lite ー一种基于运动简单混合帧的算法。
        - **10. By blocks (CPU only)** – this algorithm uses simple blending, but performs motion compensation by image blocks rather than by pixels. It runs noticeably faster than the others if GPU is not used.  
            10. 按块（仅限 CPU）——该算法使用简单的混合，但按图像块而不是按像素执行运动补偿。如果不使用 GPU，它的运行速度明显快于其他游戏。
        - **21. Simple** – this algorithm uses simple blending and applies masking, which helps reduce halos around moving objects and at frame edges.  
            21. 简单 – 该算法使用简单的混合并应用遮罩，这有助于减少移动对象周围和帧边缘的光晕。
        - **13. Standard** – a variant of 11th algorithm, without masking, but giving more smoothness with some increase in the visibility of artifacts.  
            13. 标准 – 第 11 种算法的变体，没有遮罩，但提供了更多的平滑度，同时增加了伪影的可见性。
        - **23. Complicated** – an algorithm with the most complex masking.  
            23. 复杂 – 具有最复杂掩蔽的算法。
    - **Artifacts masking** – additional masking of possible distortions of the frame areas with unreliable motion vectors. These areas can be overlaid with the areas of the original frames with some degree of transparency. The stronger the masking is, the blurrier image and the worse smoothness will be.  
        伪影遮罩 – 使用不可靠的运动矢量对帧区域可能出现的失真进行额外遮罩。这些区域可以与原始帧的区域叠加，并具有一定程度的透明度。遮罩越强，图像越模糊，平滑度越差。
        - **Disabled** – no masking is used;  
            禁用 – 不使用掩码;
        - **Weakest, Weak** – the optimal values will be used;  
            最弱，弱 – 将使用最佳值;
        - **Average** – can result in appearance of specific artifacts, for example, triple edges;  
            平均 – 可能导致出现特定伪影，例如，三边刃;
        - **Strong, Strongest** – the maximum values will be used; **not recommended for use**.  
            强，最强 – 将使用最大值;不建议使用。
2. **Motion vectors options** – the options for the search of motion vectors ("**motion estimation**"). All the options of this group significantly affect the CPU load.  
    运动矢量选项 – 用于搜索运动矢量的选项（“运动估计”）。此组的所有选项都会显着影响 CPU 负载。
    - **Motion vectors precision** – a higher accuracy in the search for motion vectors increases the smoothness of slow motion such as slow moving closing credits on a black background. High accuracy dramatically increases the use of RAM, especially if no GPU is used. For example, for playing back a video of **Ultra HD** format, more than 5 GB of RAM might be required for high accuracy.  
        运动矢量精度 – 搜索运动矢量的精度越高，慢动作的流畅度就越高，例如黑色背景上缓慢移动的片尾字幕。高精度大大增加了 RAM 的使用，尤其是在不使用 GPU 的情况下。例如，要播放超高清格式的视频，可能需要超过 5 GB 的 RAM 才能实现高精度。
    - **Motion vectors grid** – the motion vector search algorithm works with small blocks of the video frame. The smaller these blocks are, the more likely you’ll find motion of small objects, with more wave artifacts noticeable at the edges of objects.  
        运动矢量网格 – 运动矢量搜索算法适用于视频帧的小块。这些块越小，你就越有可能发现小物体的运动，在物体的边缘有更多的波浪伪影。
    - **Decrease grid step** – additional refinement of motion vectors while reducing block sizes twice.  
        减少网格步长 – 进一步细化运动矢量，同时将块大小减小两倍。
    - **Search radius** – the range of motion vector search, limits the maximum length of the vector and the degree of "**fluidity**" of the image. The larger the radius is, the more likely you’ll get a wrong vector, resulting in more interpolation artifacts.  
        搜索半径 – 运动矢量搜索的范围，限制了矢量的最大长度和图像的“流动性”程度。半径越大，就越有可能得到错误的矢量，从而导致更多的插值伪影。
        - **Small and fast** –- does not allow using the more resource-intensive SADT function to compare image blocks;  
            小而快 - 不允许使用资源密集型的 SADT 函数来比较图像块;
        - **Small, Average, Large**. 小的，一般的，大的。
    - **Wide search** – a last attempt to find the motion vector with a larger radius in case if regular search did not provide a good enough result.  
        宽搜索 – 最后一次尝试找到具有更大半径的运动矢量，以防常规搜索没有提供足够好的结果。
    - **Width of top coarse level** – for hierarchical search of motion vectors, at different levels different search options are used – particularly, at the last levels (the largest ones), more simple options are used to reduce the CPU load. The smaller this value is, the larger number of high levels will have the lower options.  
        顶部粗略级别的宽度 – 对于运动矢量的分层搜索，在不同的级别使用不同的搜索选项 - 特别是在最后级别（最大的级别），使用更简单的选项来减少 CPU 负载。此值越小，高级别的数量越多，选项就越低。
3. **Miscellaneous options 其他选项**
    - **Processing of scene changes** – the method of creating intermediate frames at the moments of scene change, that is, when there are no motion vectors available:  
        场景变化的处理 – 在场景变化的时刻创建中间帧的方法，即当没有可用的运动矢量时：
        - **Blend adjacent frames** – intermediate frames are created using simple blending of two frames; this results in smooth transition between scenes;  
            混合相邻帧 – 使用两个帧的简单混合创建中间帧;这导致了场景之间的平滑过渡;
        - **Repeat frame** – intermediate frames are copies of original frames; this results in instant scene change.  
            重复帧 – 中间帧是原始帧的副本;这会导致即时场景更改。
    - **Rendering device** – allows using a GPU device different from the one specified in the Main menu.  
        渲染设备 – 允许使用与主菜单中指定的 GPU 设备不同的 GPU 设备。
    - **Processing threads** – an addition to the Processing threads value set in the Main menu. The number of calculation threads directly affects how much RAM will be used.  
        处理线程 – 对主菜单中设置的处理线程值的补充。计算线程数直接影响将使用的 RAM 量。
        
        
        
        You can set conditions for the following "objects" and "relations".
您可以为以下“对象”和“关系”设置条件。

Basic video options:  基本视频选项：
Video frame rate – the original frame rate, is greater or less than a value specified, expressed in frames per second.
视频帧速率 – 原始帧速率大于或小于指定的值，以每秒帧数表示。
Frame width – the frame width after cropping and scaling, is greater or less than a value specified (pixels).
帧宽度 – 裁剪和缩放后的帧宽度大于或小于指定的值（像素）。
Frame height – the frame height after cropping and scaling, is greater or less than a value specified (pixels).
帧高度 – 裁剪和缩放后的帧高度大于或小于指定的值（像素）。
Frame area – the frame area (i.e. width*height) after cropping and scaling, is greater or less than a value specified (megapixels = millions of pixels).
帧区域 – 裁剪和缩放后的帧区域（即宽度*高度）大于或小于指定的值（百万像素 = 百万像素）。
Source frame area – the frame area before cropping and scaling, is greater or less than a value specified (megapixels).
源帧区域 – 裁剪和缩放前的帧区域大于或小于指定的值（百万像素）。
Names and paths:  名称和路径：
File name / URL – the file name or URL (in case of a video stream playback through a network) is equal to or contains a specified string. The string can be a regular expression (see below).
文件名/URL – 文件名或 URL（如果通过网络播放视频流）等于或包含指定的字符串。字符串可以是正则表达式（见下文）。
File extension – the file extension is equal to a specified string. The string can be a regular expression.
文件扩展名 – 文件扩展名等于指定的字符串。字符串可以是正则表达式。
Full file path – the full path to a file contains a specified string. The string can be a regular expression.
完整文件路径 – 文件的完整路径包含指定的字符串。字符串可以是正则表达式。
Video sources:  视频来源：
Is network stream – the video is a network video stream, yes or no.
是网络流 – 视频是网络视频流，是或否。
Video player – the full path to the video player executable file contains a specified string. The string can be a regular expression.
视频播放器 – 视频播放器可执行文件的完整路径包含指定的字符串。字符串可以是正则表达式。
Additional video options:
其他视频选项：
Video codec – the video codec (for example, "avc" or "h264") is equal to a specified string. The string can be a regular expression.
视频编解码器 – 视频编解码器（例如，“avc”或“h264”）等于指定的字符串。字符串可以是正则表达式。
Color depth – the video color depth is greater or less than a value specified in bits (for example, 8 bits or 10 bits).
颜色深度 – 视频颜色深度大于或小于以位为单位指定的值（例如，8 位或 10 位）。
Is stereo – the video is in 3D (stereo) format, yes or no.
立体声 – 视频是 3D（立体声）格式，是或否。
Is interlaced – the video is an interlaced video (for example, DVD or 1080i), yes or no. Such video requires pre-deinterlacing by the video player.
隔行扫描 – 视频是隔行扫描视频（例如，DVD 或 1080i），是或否。此类视频需要视频播放器进行预去隔行扫描。
Computer state:  计算机状态：
Is on battery – the computer runs on battery power, not AC, yes or no. Portable systems often have reduced performance when running on battery.
使用电池 – 计算机使用电池供电，而不是交流电，是或否。便携式系统在使用电池运行时通常会降低性能。
Other:  其他：
Each condition (that is met) from the profile’s list adds a certain number of points to the profile score; the score is shown next to the profile name in the profile selection menu. The more points a profile has, the higher priority it has. A profile with the highest score is selected when a video playback starts. Expert: add scores allows you to add any number of points to a profile score to accurately define the profile priority in "disputable cases" when several profiles equally match the video (have the same score).
配置文件列表中的每个条件（满足）都会为配置文件分数添加一定数量的分数;分数显示在配置文件选择菜单中的配置文件名称旁边。配置文件的点数越多，其优先级就越高。开始播放视频时，将选择得分最高的配置文件。专家：添加分数允许您将任意数量的分数添加到个人资料分数中，以便在多个配置文件与视频相等匹配（具有相同分数）时准确定义“有争议的情况”中的配置文件优先级。
As string "values", you can use regular expressions which are enclosed by "\" characters. For example, "\mp4|mkv\" – a regular expression, meaning a string which is equal to "mp4" OR "mkv". 
作为字符串“values”，您可以使用由“\”字符括起来的正则表达式。例如，“\mp4|mkv\” – 正则表达式，表示等于“mp4”或“mkv”的字符串。



## 代码更改参考

- **source** - source video clip  
    源 - 源视频剪辑
- **params_string** - parameters list in [JSON](http://www.json.org/) format, names quotation is optional. All parameters are optional too.  
    params_string - JSON格式的参数列表，名称引号是可选的。所有参数也是可选的。

|   |   |
|---|---|
|**{**||
|**pel**: 2, 头发： 2，|The accuracy of the motion estimation. Value can only be 1, 2 or 4. 1 means a precision to the pixel, 2 means a precision to half a pixel, 4 - to quarter pixel (not recommended to use).  <br>运动估计的准确性。值只能为 1、2 或 4。1表示精度到像素，2表示精度到半个像素，4-到四分之一像素（不建议使用）。|
|**gpu**: 0, 显卡： 0，|GPU usage mode: 0 - none, 1 - for frame rendering. Note that with "gpu:1" scaling up mode is always set to 0 cause subpixel planes are not actually used for frame rendering.  <br>GPU 使用模式：0 - 无，1 - 用于帧渲染。请注意，使用“gpu：1”时，向上缩放模式始终设置为 0，因为子像素平面实际上并未用于帧渲染。|
|**full**: true, 完整：真，|Turns on reduced super clip size when full=false, valid only with pel=1. It saves some memory and can be useful for processing extra large frames (like UHD (4K)).  <br>当 full=false 时打开减小的超级剪辑大小，仅在 pel=1 时有效。它可以节省一些内存，可用于处理超大帧（如UHD（4K））。|
|**scale**: **{** 比例：{|Scaling modes:  缩放模式：|
|**up**: 2, 向上： 2，|Subpixel interpolation method for pel=2,4.  <br>pel=2，4的亚像素插值法。<br><br>- 0 for soft interpolation (bilinear),  <br>    0 表示软插值（双线性），<br>- 1 for bicubic interpolation (4 tap Catmull-Rom),  <br>    1 用于双三次插值（4 抽头 Catmull-Rom），<br>- 2 for sharper Wiener interpolation (6 tap, similar to Lanczos).  <br>    2 用于更清晰的维纳插值（6 次抽头，类似于 Lanczos）。|
|**down**: 4 下： 4|Hierarchical levels smoothing and reducing (halving) filter.  <br>分层级别平滑和减少（减半）过滤器。<br><br>- 0 is simple 4 pixels averaging like unfiltered SimpleResize (old method);  <br>    0 是简单的 4 像素平均，就像未过滤的简单调整大小（旧方法）;<br>- 1 is triangle (shifted) filter like ReduceBy2 for more smoothing (decrease aliasing);  <br>    1 是三角形（移位）滤波器，如 ReduceBy2，用于更多平滑（减少混叠）;<br>- 2 is triangle filter like BilinearResize for even more smoothing;  <br>    2是三角形滤波器，如双线性调整大小，以实现更多的平滑;<br>- 3 is quadratic filter for even more smoothing;  <br>    3是二次滤波器，更加平滑;<br>- 4 is cubic filter like BicubicResize(b=1,c=0) for even more smoothing.  <br>    4 是立方滤波器，如 BicubicResize（b=1，c=0），以实现更多的平滑。|
|**}**||
|**rc**: 0, RC： 0，|Used by the SVP Manager only. You don't need to set this in your own scripts.  <br>仅供高级副总裁经理使用。您无需在自己的脚本中进行此设置。|
|**}**||

#### SVAnalyse(super, params_string, [src]: clip)  
SVAnalyse（super， params_string， [src]： clip）

Get prepared multilevel super clip, estimate motion by block-matching method and produce special output clip with motion vectors data used by **SVSmoothFps** function. Some hierarchical multi-level search methods are implemented (from coarse image scale to finest).  
准备好多级超级剪辑，通过块匹配方法估计运动，并使用SVSmoothFps函数使用的运动矢量数据生成特殊的输出剪辑。实现了一些分层多级搜索方法（从粗略的图像比例到最精细）。

- **super** - multilevel super clip prepared by SVSuper function. You can replace this clip with **[MSuper](http://avisynth.org.ru/mvtools/mvtools2.html#functions)** clip from original **MVTools 2.5** in which case you should define "gpu" parameter here.  
    超级 - 由SVSuper功能准备的多级超级剪辑。您可以将此剪辑替换为原始 MVTools 2.5 中的 MSuper 剪辑，在这种情况下，您应该在此处定义“gpu”参数。
- **params_string** - parameters list in JSON format.  
    params_string - JSON 格式的参数列表。
- **src** - source clip, must be defined when using reduced super clip ("super.full"=false).  
    src - 源剪辑，必须在使用缩减的超级剪辑时定义（“super.full”=false）。

|   |   |
|---|---|
|**{**||
|**gpu**: 0, 显卡： 0，|GPU usage mode: 0 - none, 1 - for frame rendering. Should be used instead of "super.gpu" if and only if **SVSuper** is replaced with **MSuper**!  <br>GPU 使用模式：0 - 无，1 - 用于帧渲染。应该使用代替“super.gpu”当且仅当SVSuper被MSuper替换时！|
|**vectors**: 3, 向量： 3，|Direction of motion vectors to search for.  <br>要搜索的运动矢量的方向。<br><br>- 1 - forward only, from current frame to the following one (not useful at all),  <br>    1 - 仅向前，从当前帧到下一帧（根本没有用），<br>- 2 - backward only, from following frame to the current one (useful only with "smoothfps.algo: 1"),  <br>    2 - 仅向后，从以下帧到当前帧（仅适用于“smoothfps.algo：1”），<br>- 3 - search both directions.  <br>    3 - 双向搜索。|
|**block**: **{** 块：{|Defines vectors grid step and block sizes for block matching algorithm.  <br>定义块匹配算法的向量网格步长和块大小。|
|**w**: 16, 在： 16，|Size of a block (horizontal). It's either 8, 16 or 32. Larger blocks are less sensitive to noise, are faster, but also less accurate, smaller blocks produce more wavy picture.  <br>块的大小（水平）。它是 8、16 或 32。较大的块对噪声不太敏感，速度更快，但准确性也较低，较小的块产生更多的波浪图像。|
|**h**: 16, 高： 16，|Vertical size of a block. Default is equal to horizontal size. Additional options are: 4 for "block.w:8", 8 for "block.w:16", 16 for "block.w:32".  <br>块的垂直大小。默认值等于水平大小。其他选项包括：4 表示“block.w：8”，8 表示“block.w：16”，16 表示“block.w：32”。|
|**overlap**: 2 重叠：2|Block overlap value. 0 - none, 1 - 1/8 of block size in each direction, 2 - 1/4 of block size, 3 - 1/2 of block size. The greater overlap, the more blocks number, and the lesser the processing speed.  <br>块重叠值。0 - 无，每个方向的块大小为 1 - 1/8，块大小的 2 - 1/4，块大小的 3 - 1/2。重叠越大，块数越多，处理速度越慢。<br><br>Resulting overlap value in pixels should be even with CPU rendering.  <br>生成的重叠值（以像素为单位）应与 CPU 渲染一致。|
|**}**,||
|**main**: **{** 主：{|Defines main search settings.  <br>定义主搜索设置。|
|**levels**: 0, 级别： 0，|Positive value is the number of levels used in the hierarchical analysis made while searching for motion vectors. Negative or zero value is the number of coarse levels NOT used in the hierarchical analysis made while searching for motion vectors.  <br>正值是在搜索运动矢量时进行的层次分析中使用的水平数。负值或零值是在搜索运动矢量时进行的分层分析中未使用的粗略级别数。|
|**search**: **{** 搜索： {||
|**type**: 4, 类型： 4，|The type of search on finest level:  <br>最精细级别的搜索类型：<br><br>- 2 - Hexagon search, similar to x264,  <br>    2 - 六边形搜索，类似于 x264，<br>- 3 - Uneven Multi Hexagon (UMH) search, similar to x264,  <br>    3 - 不均匀的多六边形 （UMH） 搜索，类似于 x264，<br>- 4 - Exhaustive search, slowest but it gives the best results.  <br>    4 - 详尽的搜索，最慢，但它给出了最好的结果。|
|**distance**: -2*pel, 距离： -2*佩尔，|Search range on finest level:  <br>最佳级别的搜索范围：<br><br>- 0 - don't search on finest level at all, greatly increase search speed but may still looks good with GPU rendering. This option is opposite to "super.pel".  <br>    0 - 根本不在最精细的级别上搜索，大大提高了搜索速度，但使用 GPU 渲染可能仍然看起来不错。此选项与“super.pel”相反。<br>- >0 - classic fixed range in pixels.  <br>    >0 - 经典的固定范围（以像素为单位）。<br>- <0 - "adaptive" range based on block local contrast. Range is small or zero for low contrast blocks (black/gray for example) but is big for blocks that has many visible details. Effective average range in common scenes is about 1/3 of this value.  <br>    <0 - 基于块局部对比度的“自适应”范围。对于低对比度块（例如黑色/灰色），范围很小或为零，但对于具有许多可见细节的块，范围很大。常见场景中的有效平均范围约为该值的 1/3。|
|**sort**: true, 排序：对，|Sort vectors from previous level by SAD values to define the order of blocks scanning so the search begins with better predictors. This option is always ON on coarse levels but may be time consuming on finest one.  <br>按 SAD 值对先前水平的向量进行排序，以定义块扫描的顺序，以便搜索从更好的预测因子开始。此选项在粗略级别上始终打开，但在最精细的水平上可能很耗时。|
|**satd**: false, SATD：假，|Use SATD function instead of SAD on **finest** level. Extremely slow, do not use it!  <br>使用SATD功能而不是最精细级别的SAD。极慢，不要用！|
|**coarse**: **{** 粗略：{|The same parameters for coarse levels.  <br>粗略水平的参数相同。|
|**width**: 1050, 宽度： 1050，|Maximum width of a level to be processed with 'coarse' parameters. Can be useful to save CPU power when processing extra large frames (like UHD (4K)).  <br>使用“粗略”参数处理的级别的最大宽度。在处理超大帧（如超高清 （4K））时，可用于节省 CPU 功率。|
|**type**: 4, 类型： 4，|Same as "main.search.type".  <br>与“main.search.type”相同。|
|**distance**: 0, 距离： 0，|Same as "main.search.type" except zero means "-10".  <br>与“main.search.type”相同，但零表示“-10”。|
|**satd**: true, SATD：对，|Use SATD function instead of SAD on every coarse level, improves motion vector estimation at luma flicker and fades.  <br>在每个粗略级别上使用 SATD 功能代替 SAD，改进亮度闪烁和淡入淡出时的运动矢量估计。|
|**trymany**: false, 尝试：假，|Try to start searches around many predictors.  <br>尝试围绕许多预测变量开始搜索。|
|**bad**: **{** 不好：{|Wide second search for bad vectors.  <br>广泛秒搜索不良向量。|
|**sad**: 1000, 悲伤： 1000，|SAD threshold to define "bad" vectors. Value is scaled to block size 8x8.  <br>SAD 阈值用于定义“坏”向量。值缩放到块大小 8x8。|
|**range**: -24 范围： -24|The range of wide search for bad blocks. Use positive value for UMH search and negative for Exhaustive search.  <br>搜索坏块的范围广。对 UMH 搜索使用正值，对穷举搜索使用负值。|
|**}**||
|**}**||
|**}**,||
|**penalty**: **{** 处罚：{|Main search penalties for motion coherence.  <br>运动连贯性的主要搜索惩罚。|
|**lambda**: 10.0, λ： 10.0，|Set the coherence of the field of vectors. The higher, the more coherent. However, if set too high, some best motion vectors can be missed.  <br>设置向量场的相干性。越高，越连贯。但是，如果设置得太高，可能会错过一些最佳运动矢量。<br><br>This value is different from MVTools, see [remark](https://www.svp-team.com/wiki/Manual:SVPflow#plevel) for explanations.  <br>此值与 MVTool 不同，有关说明，请参阅备注。|
|**plevel**: 1.5, 等级： 1.5，|penalty.lambda scaling mode between levels. 1.0 means no scaling, 2.0 - linear, 4.0 - quadratic dependence from hierarchical level number.  <br>惩罚.lambda 在级别之间缩放模式。1.0 表示无缩放，2.0 - 线性，4.0 - 与分层级别数的二次依赖性。<br><br>This value is different from MVTools, see [remark](https://www.svp-team.com/wiki/Manual:SVPflow#plevel) for explanations.  <br>此值与 MVTool 不同，有关说明，请参阅备注。|
|**lsad**: 8000, LSAD： 8000，|SAD limit for lambda using. Local lambda is smoothly decreased if SAD value of vector predictor is greater than the limit. It prevents bad predictors using but decreases the motion coherence. Value is scaled to block size 8x8.  <br>使用λ的SAD限制。如果向量预测因子的 SAD 值大于极限，则局部 lambda 平滑减小。它可以防止使用不良预测因子，但会降低运动相干性。值缩放到块大小 8x8。|
|**pnew**: 50, 新： 50，|Relative penalty (scaled to 256) to SAD cost for new candidate vector. New candidate vector must be better will be accepted as new vector only if its SAD with penalty (SAD + SAD*pnew/256) is lower then predictor cost (old SAD). It prevent replacing of quite good predictors by new vector with a little better SAD but different length and direction.  <br>新候选载体的 SAD 成本的相对惩罚（缩放到 256）。只有当带有惩罚的 SAD （SAD + SAD*pnew/256） 低于预测因子成本（旧 SAD）时，新的候选向量必须更好才会被接受为新向量。它可以防止用具有更好的 SAD 但长度和方向不同的新向量替换相当好的预测因子。|
|**pglobal**: 50, 全球： 50，|Relative penalty (scaled to 256) to SAD cost for global predictor vector (lambda is not used for global vector).  <br>全局预测变量向量的 SAD 成本的相对惩罚（缩放到 256）（λ 不用于全局向量）。|
|**pzero**: 100, pzero： 100，|Relative penalty (scaled to 256) to SAD cost for zero vector. It prevent replacing of quite good predictor by zero vector with a little better SAD (lambda is not used for zero vector).  <br>零向量的相对惩罚（缩放到 256）对 SAD 成本。它可以防止用更好的 SAD 将相当好的预测因子替换为零向量（lambda 不用于零向量）。|
|**pnbour**: 50, PNBOUR： 50，|Relative penalty (scaled to 256) to SAD cost for up to 8 neighbours vectors.  <br>最多 8 个邻居向量的相对惩罚（缩放到 256）对 SAD 成本。|
|**prev**: 0, 上一页： 0，|Relative penalty (scaled to 256) to SAD cost for "reverse" vector (already found vector from reverse search direction), works only with "analyse.vectors: 3".  <br>“反向”向量（已经从反向搜索方向找到的向量）的相对惩罚（缩放到 256）对 SAD 成本，仅适用于“analyse.vectors：3”。|
|**}**||
|**}**,||
|**refine**: **[ {** 细化： [ {|Array of structures, each element defines additional level of recalculation, on each level blocks are divided by 4. Replaces MRecalculate function.  <br>结构数组中，每个元素定义额外的重新计算级别，在每个级别上块除以4。替换 MRecomputing 函数。<br><br>Interpolated vectors of old blocks are used as predictors for new vectors, with recalculation of SAD.  <br>旧块的插值向量用作新向量的预测因子，并重新计算SAD。|
|**thsad**: 200, 萨德： 200，|Only bad quality new vectors with SAD above this threshold will be re-estimated by search. Good vectors are not changed, but its SAD will be updated (re-calculated). Value is scaled to block size 8x8.  <br>只有SAD高于此阈值的劣质新载体才会通过搜索重新估计。好的向量不会改变，但其SAD将被更新（重新计算）。值缩放到块大小 8x8。<br><br>Zero means "do not refine, just divide"  <br>零表示“不精炼，只除”|
|**search**: **{** 搜索： {|Search parameters.  搜索参数。|
|**type**: 4, 类型： 4，|Same as main.search.type by default.  <br>默认情况下与 main.search.type 相同。|
|**distance**: pel, 距离： 佩尔，|Same as super.pel value by default.  <br>默认情况下与 super.pel 值相同。|
|**satd**: false 星期六：假|Same as main.search.satd by default.  <br>默认情况下与main.search.satd相同。|
|**}**,||
|**penalty**: **{** 处罚：{||
|**pnew**: 50 新： 50|Same as main.penalty.pnew by default.  <br>默认情况下与main.penalty.pnew相同。|
|**}**||
|**} ]**,||
|**special**: **{** 特殊：{|Some special parameters not used in SVP  <br>SVP中未使用的一些特殊参数|
|**delta**: 1 增量：1|Interval between analysed frames.  <br>分析帧之间的间隔。|
|**}**||
|**}**||

#### SVConvert(vectors, isb: bool)  
SVConvert（vectors， isb： bool）

Convert SVAnalyse output to the format of MAnalyse compatible with "client" MVTools 2.5 functions.  
将 SVAnalyse 输出转换为与“客户端”MVTools 2.5 函数兼容的 MAnalyse 格式。

- **vectors** - motion vectors data produced by SVAnalyse function,  
    向量 - 由SVAnalyse函数产生的运动向量数据，
- **isb** - which vectors to extracts: forward if **isb=false**, backward if **isb=true**.  
    ISB - 要提取的向量：如果 ISB=false，则向前，如果 ISB=true，则向后。

   super = SVSuper(super_params)
   vectors = SVAnalyse(super, analyse_params)
   
   forward_mv = SVConvert(vectors, false)
   backward_mv = SVConvert(vectors, true)
   
   super_mv = MSuper(pel=1, hpad=0, vpad=0) **#padding should be zero here!**
   MFlowFps(super_mv, backward_mv, forward_mv, num=60, den=1)

#### Remark: lambda/plevel values meaning.  
备注：λ/plevel值含义。

Let the finest level number is 0 and we've got N levels total => the smallest level number is N-1.  
设最精细的级别数为 0，我们总共有 N 个级别 => 最小的级别数为 N-1。  
**MVTools approach: MVTools 方法：**

   <local lambda value at level K> = lambda * (2^(K*plevel)), where lambda is integer and plevel is integer in [0;2]

**SVPflow approach: 高级流程方法：**

   <local lambda value at level K> = lambda * 1000 / (plevel^(N-1-K)), where both lambda and plevel are floats.

Benefits - lambda penalty is now invariant to video frame size.  
优点 - lambda 惩罚现在对视频帧大小不变。

### svpflow2

A closed-source frame rendering plugin.  
一个闭源帧渲染插件。

#### SVSmoothFps(source, super, vectors, params_string, [sar]: float, [mt]: integer)  
SVSmoothFps（source， super， vectors， params_string， [sar]： float， [mt]： integer）

Will change the framerate (fps) and number of frames of the source clip. The function can be use for framerate conversion, slow-motion effect, etc. It uses motion vectors found with SVAnalyse function to create interpolated pictures at some intermediate time moments between frames. Some internal masks (cover/uncover, vectors quality) can be used to produce the output image with minimal artifacts.  
将更改源剪辑的帧速率 （fps） 和帧数。该功能可用于帧率转换、慢动作效果等。它使用通过 SVAnalyse 函数找到的运动矢量在帧之间的某个中间时间点创建插值图片。一些内部遮罩（覆盖/取消覆盖、矢量质量）可用于生成具有最小伪影的输出图像。

- **source** - source video clip.  
    源 - 源视频剪辑。
- **super** - multilevel super clip prepared by SVSuper function.  
    超级 - 由SVSuper功能准备的多级超级剪辑。
- **vectors** - motion vectors data produced by SVAnalyse function.  
    矢量 - 由 SVAnalyse 函数生成的运动矢量数据。
- **params_string** - parameters list in JSON format.  
    params_string - JSON 格式的参数列表。
- **sar** - optional, can be used instead of "light.sar" inside ffdshow:  
    sar - 可选，可以代替ffdshow中的“light.sar”：

   SVSmoothFps(..., sar=float(ffdshow_sar_x)/ffdshow_sar_y, ...)

- **mt** - optional, workaround for current Avisynth 2.6 MT build ver. 2.6.0.3, should be equal to number of threads defined in SetMTMode():  
    mt - 可选，当前 Avisynth 2.6 MT 构建版本 2.6.0.3 的解决方法应等于 SetMTMode（） 中定义的线程数：

   threads = 10
   SetMTMode(3,**threads**)
   #....
   SVSmoothFps(..., mt=**threads**, ...)

|   |   |
|---|---|
|**{**||
|**rate**: **{** 速率： {|Target frame rate.  目标帧速率。|
|**num**: 2, 数字： 2，|Numerator of multiplier for frame rate change.  <br>帧速率变化的乘数分子。|
|**den**: 1, 书房： 1，|Denominator of multiplier for frame rate change.  <br>帧速率变化的乘数分母。|
|**abs**: false 腹肌：假|If **true** then num/den define absolute frame rate value instead if multiplier for source frame rate.  <br>如果为 true，则 num/den 定义绝对帧速率值，而不是源帧速率的乘数乘数。|
|**}**,||
|**algo**: 13, 东西：13，|Rendering algorithm or "SVP shader", available values are:  <br>渲染算法或“SVP 着色器”，可用值为：<br><br>- 1 - sharp picture without any blending, moves pixels by motion vectors from next frame to current. Requires only backward motion vectors ("analyse.vectors: 2") so it's the fastest possible method.  <br>    1 - 没有任何混合的清晰图像，通过运动矢量将像素从下一帧移动到当前帧。只需要向后运动矢量（“analyse.vectors：2”），因此它是最快的方法。<br>- 2 - like 1st but moves pixels from the nearest (in terms of time) frame so it uses both backward and forward vectors. Recommended for 2D animations.  <br>    2 - 与 1st 类似，但从最近的（就时间而言）帧移动像素，因此它同时使用向后和向前矢量。建议用于 2D 动画。<br>- 11 - time weighted blend of forward and backward partial motion compensations.  <br>    11 - 向前和向后部分运动补偿的时间加权混合。<br>- 13 - same as 11th but with dynamic median added. Produces minimum artifacts but with noticeable halos around moving objects.  <br>    13 - 与第 11 位相同，但添加了动态中位数。产生最少的伪影，但在移动对象周围有明显的光晕。<br>- 21 - 11th plus additional cover/uncover masking to minimize halos and improve frame edges.  <br>    21 - 11 加上额外的遮盖/揭盖遮罩，以最大限度地减少光晕并改善框架边缘。<br>- 23 - 21th plus extra vectors from adjacent frames for further decreasing of halos, can be less smooth than 21th.  <br>    23 - 21 加上来自相邻帧的额外矢量以进一步减少光晕，可能不如 21 日平滑。|
|**block**: false, 块：假，|Use block-based motion compensation instead of pixel-based. Always OFF with GPU rendering enabled.  <br>使用基于块的运动补偿，而不是基于像素的运动补偿。启用 GPU 渲染时始终关闭。|
|**cubic**: 1, 立方体： 1，|Only works with GPU rendering enabled:  <br>仅适用于启用 GPU 渲染的情况：<br><br>- 0 - use bilinear interpolation for motion vectors and all masks,  <br>    0 - 对运动矢量和所有掩码使用双线性插值，<br>- 1 - use bicubic interpolation  <br>    1 - 使用双三次插值|
|**gpuid**: 0, GPUID： 0，|Defines which video card should be used for rendering, only works with GPU rendering enabled:  <br>定义应使用哪个视频卡进行渲染，仅适用于启用 GPU 渲染的情况：<br><br>- 0 - default (use 1st available GPU),  <br>    0 - 默认值（使用第一个可用的 GPU），<br>- 11 - use **1st** GPU device on **1st** OpenCL platfrom,  <br>    11 - 在第一个 OpenCL 平台上使用第一个 GPU 设备，<br>- 12 - use **2nd** GPU device on **1st** OpenCL platfrom,  <br>    12 - 在第一个 OpenCL 平台上使用第二个 GPU 设备，<br>- 21 - use **1st** GPU device on **2nd** OpenCL platfrom an so on.  <br>    21 - 在第二个 OpenCL 平台上使用第一个 GPU 设备，依此类推。|
|**linear**: true, 线性：真，|Only works with GPU rendering enabled. When set to "true" frame rendering is done in linear light.  <br>仅适用于启用 GPU 渲染的情况。当设置为“真实”时，帧渲染是在线性光线下完成的。|
|**mask**: **{** 面具：{|Masks properties.  遮罩属性。|
|**cover**: 100, 封面： 100，|Cover/uncover mask strength, more means "more strong mask". Recommended values 50-100.  <br>覆盖/揭开面膜强度，更多意味着“更坚固的面膜”。建议值 50-100。|
|**area**: 0, 面积： 0，|Bad areas (identified by vector's SAD values) mask, more means "more strong mask". Recommended value is 100, but it can dramatically reduce smoothness effect.  <br>坏区域（由矢量的SAD值标识）掩码，更多意味着“更强的掩码”。建议值为 100，但它会大大降低平滑度效果。|
|**area_sharp**: 1.0 area_sharp： 1.0|Defines the exponent of relation between SAD and area mask values.  <br>定义 SAD 和区域掩码值之间关系的指数。|
|**}**,||
|**scene**: **{** 场景：{|Extended "scene change" controls.  <br>扩展的“场景更改”控件。|
|**mode**: 3, 模式： 3，|Frames interpolation mode:  <br>帧插值模式：<br><br>- 0 - uniform interpolation for maximum smoothness. For example for 24->60 conversion output will be: "1mmmm1mmmm...", where "1" stands for original frame and "m" for interpolated one.  <br>    0 - 均匀插值以获得最大平滑度。例如，对于 24->60 转换输出将为：“1mmmm1mmmm...”，其中“1”代表原始帧，“m”代表插值帧。<br>- 1 - "1m" mode that gives "1mm1m1mm1m..." output in the above example => less artifacts at the cost of less smoothness.  <br>    1 - “1m”模式，给出“1mm1m1mm1m...”上面示例中的输出 => 更少的伪影，但代价是平滑度较低。<br>- 2 - "2m" mode: "1m11m11m11..." => much less artifacts and much less smoothness.  <br>    2 - “2m”模式：“1m11m11m11...” => 更少的伪影和更少的平滑度。<br>- 3 - adaptive mode that switches between modes 0,1,2 based on overall vector field quality.  <br>    3 - 自适应模式，根据整体矢量场质量在模式 0、1、2 之间切换。|
|**blend**: false, 混合：假，|Blend frames at scene change like ConvertFps if true, or repeat last frame like ChangeFps if false.  <br>在场景更改时混合帧（如果为真，则为“转换帧”），如果为真，则重复最后一帧（如“更改帧数”）。|
|**limits**: **{** 限制：{|Limits for vector field quality / scene change detection.  <br>矢量场质量/场景变化检测的限制。<br><br>For example scene change will be detected if number of blocks with "adjusted SAD" > "limits.scene" will be more than "limits.blocks" percents of all blocks, that has "adjusted SAD" value > "limits.zero", where "adjusted SAD" is "block SAD"/"block average luma".  <br>例如，如果具有“调整后的SAD”>“limits.scene”的块数将超过所有块的“限制.块”百分比，则检测到场景变化，该块具有“调整后的SAD”值>“限制.零”，其中“调整后的SAD”是“块SAD”/“块平均亮度”。|
|**m1**: 1600, M1： 1600，|Limit for changing uniform mode to "1m".  <br>将统一模式更改为“1m”的限制。|
|**m2**: 2800, m2： 2800，|Limit for changing "1m" mode to "2m".  <br>将“1m”模式更改为“2m”的限制。|
|**scene**: 4000, 场景：4000，|Limit for scene change detection.  <br>场景更改检测的限制。|
|**zero**: 200, 零： 200，|Vectors with "adjusted SAD" less than this value are excluded from consideration.  <br>“调整后的SAD”小于此值的向量被排除在考虑之外。|
|**blocks**: 20 块： 20|Threshold which sets how many blocks in percents have to change.  <br>设置必须更改多少块（以百分比表示）的阈值。|
|**}**,||
|**luma**: 1.5 旧： 1.5|Additional correction parameter for "average luma" value.  <br>“平均亮度”值的附加校正参数。|
|**}**,||
|**light**: **{** 光：{|"Ambilight"-like black fields lighting.  <br>类似“流光溢彩”的黑场照明。|
|**aspect**: 0.0, 宽高比： 0.0，|Screen aspect ratio defines black fields height (or width) and output video frame size.  <br>屏幕纵横比定义黑场高度（或宽度）和输出视频帧大小。|
|**sar**: 1.0, SAR： 1.0，|Source video pixel aspect ratio.  <br>源视频像素长宽比。|
|**zoom**: 0.0, 变焦：0.0，|"Glow" (or "zoom out") effect size, in percents of original frame size.  <br>“发光”（或“缩小”）效果大小，以原始帧大小的百分比表示。|
|**lights**: 16, 灯： 16，|Lights count.  灯光计数。|
|**length**: 100, 长度： 100，|Flare length in percents.  <br>以百分比表示的耀斑长度。|
|**cell**: 1.0, 单元格： 1.0，|Width of every light.  每盏灯的宽度。|
|**border**: 12 边框：12|Height of averaging frame border.  <br>平均框架边框的高度。|
|**}**||
|**}**||

#### SVSmoothFps_NVOF(source, params_string, ...)  
SVSmoothFps_NVOF（来源，params_string，...


The same as SVSmoothFps but the motion vectors are acquired in-place via [NVidia Optical Flow API](https://developer.nvidia.com/opticalflow-sdk) so there's no need for SVSuper/SVAnalyse at all.  
与SVSmoothFps相同，但运动矢量是通过NVidia Optical Flow API就地获取的，因此根本不需要SVSuper/SVAnalyse。

### Samples 样品

#### Basic Avisynth script 基本 Avisynth 脚本

   SetMemoryMax(1024)
   LoadPlugin("svpflow1.dll")
   LoadPlugin("svpflow2.dll")
   
   threads=9
   SetMTMode(3,threads)
   # Some input here
   SetMTMode(2)
   ConvertToYV12()
   
   # All parameters set to defaults which means high quality frame doubling
   super=SVSuper("{gpu:1}")
   vectors=SVAnalyse(super, "{}")
   SVSmoothFps(super, vectors, "{}", mt=threads)

#### Basic Vapoursynth script 基本蒸汽合成器脚本

   import vapoursynth as vs
   core = vs.get_core(threads=9)
   
   core.std.LoadPlugin("svpflow1_vs.dll")
   core.std.LoadPlugin("svpflow2_vs.dll")
   
   clip = # need some input here
   clip = clip.resize.Bicubic(format=vs.YUV420P8) #convert to YV12
   
   super  = core.svp1.Super(clip,"{gpu:1}")
   vectors= core.svp1.Analyse(super["clip"],super["data"],clip,"{}")
   smooth = core.svp2.SmoothFps(clip,super["clip"],super["data"],vectors["clip"],vectors["data"],"{}")
   smooth = core.std.AssumeFPS(smooth,fpsnum=smooth.fps_num,fpsden=smooth.fps_den)
   
   smooth.set_output()

All other scripts are the same except for different JSON strings. For example:  
除不同的 JSON 字符串外，所有其他脚本都是相同的。例如：

#### Maximum smoothness for animation  
动画的最大平滑度

   # Header is exactly same as in previous example
   
   super=SVSuper("**{gpu:1}**")
   # Small 8x8 blocks with additional refine to 4x4
   vectors=SVAnalyse(super, "**{ block:{w:8}, refine:[{thsad:1000}] }**")
   # Conversion to 5/2 of source frame rate with 2nd SVP-shader.
   SVSmoothFps(super, vectors, "**{ num:5, den:2, algo:2 }**", mt=threads)

#### More JSON magic 更多 JSON 用法

Multi-line JSON string with comments inside it:  
包含注释的多行 JSON 字符串：

   analyse_params="""{block:{w:8,overlap:1},
   	main:
   		{search:
   			{type:2,distance:-2,satd:true,
   			coarse:{trymany:true}
   			}
   		// the following line is commented out in C++-style 
   		//,penalty:{plevel:1.0,lambda:1.0}
   		}
   }"""
   # ...
   vectors=SVAnalyse(super, analyse_params)
   # ...