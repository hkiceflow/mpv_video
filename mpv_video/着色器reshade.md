# 简化版讲解：

Anime4K v3.2-v4.x
它是一组开源的高质量的实时动漫缩放/降噪算法。
在v1之前是个纯粹的锐化滤镜，v2引入人工智能卷积核，在v3之后进行了模块化改造，目前版本v4在局部场景下能达到waifu2x的效果。

A4k不提供cscale色度升频类着色器。(v3.2-v4.x版理论上不兼容之前的旧版本，v3-v3.1版的区别说明见 附录 部分)

US → S → M → L → VL → UL → UUL 性能要求逐渐提高（处理耗时大致加倍），处理结果越好

去模糊系列：避免过冲和振铃的情况下锐化细节。
（推荐 Anime4K_Deblur_DoG.glsl 变体）

Anime4K_Deblur_DoG.glsl
Anime4K_Deblur_Original.glsl
降噪系列： Mean → Mode → Median 速度逐渐变慢。
（推荐 Anime4K_Denoise_Bilateral_Mode.glsl 变体）

Anime4K_Denoise_Bilateral_Mean.glsl
Anime4K_Denoise_Bilateral_Mode.glsl
Anime4K_Denoise_Bilateral_Median.glsl
线条加深、变细系列：
VeryFast → Fast → HQ 速度逐渐变慢。
（推荐 Anime4K_Darken_HQ.glsl 和 Anime4K_Thin_HQ.glsl 变体）

Anime4K_Darken_VeryFast.glsl
Anime4K_Darken_Fast.glsl
Anime4K_Darken_HQ.glsl

Anime4K_Thin_VeryFast.glsl
Anime4K_Thin_Fast.glsl
Anime4K_Thin_HQ.glsl
线条重建系列：
开发者推荐在upscale之前使用，减少上采样后产生的伪影。
Soft 为更适合与downscale一起使用，可用于下采样抗锯齿。 GAN 变体使用生成型对抗网络，通常比 CNN 具有更高的质量。
（推荐 Anime4K_Restore_CNN_M.glsl 变体）

Anime4K_Restore_CNN_S.glsl
Anime4K_Restore_CNN_M.glsl
Anime4K_Restore_CNN_L.glsl
Anime4K_Restore_CNN_VL.glsl
Anime4K_Restore_CNN_UL.glsl
Anime4K_Restore_CNN_Soft_S.glsl
Anime4K_Restore_CNN_Soft_M.glsl
Anime4K_Restore_CNN_Soft_L.glsl
Anime4K_Restore_CNN_Soft_VL.glsl
Anime4K_Restore_CNN_Soft_UL.glsl
Anime4K_Restore_GAN_UL.glsl
Anime4K_Restore_GAN_UUL.glsl
放大系列：
CNN/GAN 变体最小缩放触发倍率为1.2。
Original 变体始终执行二倍放大且无缩放触发倍率限制。 x2 x3 x4 为放大倍率

Anime4K_Upscale_CNN_x2_S.glsl
Anime4K_Upscale_CNN_x2_M.glsl
Anime4K_Upscale_CNN_x2_L.glsl
Anime4K_Upscale_CNN_x2_VL.glsl
Anime4K_Upscale_CNN_x2_UL.glsl
Anime4K_Upscale_GAN_x2_S.glsl
Anime4K_Upscale_GAN_x2_M.glsl
Anime4K_Upscale_GAN_x3_L.glsl
Anime4K_Upscale_GAN_x3_VL.glsl
Anime4K_Upscale_GAN_x4_UL.glsl
Anime4K_Upscale_GAN_x4_UUL.glsl
Anime4K_Upscale_Original_x2.glsl
放大为主的混合系列：
以下除 Deblur_Original （无限制）外，最小缩放触发倍率皆为1.2。

Anime4K_Upscale_DoG_x2.glsl
Anime4K_Upscale_DTD_x2.glsl
Anime4K_Upscale_Deblur_Original_x2.glsl
Anime4K_Upscale_Deblur_DoG_x2.glsl
Anime4K_Upscale_Denoise_CNN_x2_S.glsl
Anime4K_Upscale_Denoise_CNN_x2_M.glsl
Anime4K_Upscale_Denoise_CNN_x2_L.glsl
Anime4K_Upscale_Denoise_CNN_x2_VL.glsl
Anime4K_Upscale_Denoise_CNN_x2_UL.glsl
其它系列：
AutoDownscalePre 防止过度放大超越显示分辨率，避免额外一步的downscale处理。
x2版常用于2k屏全屏观看1080p执行二倍放大过度（4k目标分辨率远超显示设备分辨率），也可用于4k屏两次放大720p视频。
该着色器放在首个放大着色器之后。x4版放在两次放大着色器之间。

Clamp 主要用于钳制画面的高光，抗振铃和减少过冲。
该着色器放在所有后处理着色器之前或（推荐）之后。

3DGraphics 主要用于游戏类3d画面放大。AA为抗锯齿版本。（无缩放倍率限制）

Anime4K_AutoDownscalePre_x2.glsl
Anime4K_AutoDownscalePre_x4.glsl
Anime4K_Clamp_Highlights.glsl
Anime4K_3DGraphics_Upscale_x2_US.glsl
Anime4K_3DGraphics_AA_Upscale_x2_US.glsl
补充说明：对新版的混合搭配顺序为 Clamp → Restore → Upscale → AutoDownscalePre → Upscale …（仅作为推荐，可自行调节删改）
通常仅需一个 Anime4K_Restore_CNN_M.glsl 模块即满足大多数人的口味（适度画面修复+弱感知强化+少量瑕疵引入）

Anime4k-legacy
此处专指旧版不带放大功能的Anime4k v1及之前的版本，可作为动漫向专用的锐化器独立或搭配其它放大着色器使用，实现不错的最终效果。
已降低v1中不合理的缩放倍率限制。 10系列中被开发者视为最佳质量的变体反而被我认为质量最差（扭曲文字图形且油画感太重）

🔺 变体 10 的最小缩放触发倍率为1

相关列表：（推荐程度 09 >> 10_UltraFast > 10_Fast > 10 ）

Anime4K_legacy_09.glsl
Anime4K_legacy_10.glsl
Anime4K_legacy_10_Fast.glsl
Anime4K_legacy_10_UltraFast.glsl
☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲

ACNet
是Anime4KCPP-Net的缩写，设计用于高性能动画风格的图像和视频放大，它与Asymmetric Convolution Net(缩写重名ACNet)无关，与现在的Anime4k也无太大关联。ACNet是Anime4KCPP自己的基于CNN的算法。

🔺 启用将覆盖 mpv.conf 中指定的 --scale=xxxxx 算法
🔺 最小缩放触发倍率为1.2

副作用： HDN 变体能更好的降噪，等级1 → 2 → 3，越高降噪效果越好，但可能导致模糊和缺少细节。

相关列表：TianZerL-acnet

ACNet.glsl
ACNet_HDN_L1.glsl
ACNet_HDN_L2.glsl
ACNet_HDN_L3.glsl
☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲

Chroma from Luma (CfL) Prediction
由现代视频编码方式启发的色度还原算法

🔺 启用将覆盖 mpv.conf 中指定的 --cscale=xxxxx 算法

joint-bilateral
简化的双边滤波色度还原算法，利用亮度信息为引导。

🔺 启用将覆盖 mpv.conf 中指定的 --cscale=xxxxx 算法

pixel-clipper
简易像素裁切，用于通用的后处理抗振铃。

以上三项由同一开发者移植，在项目中提供了更多说明。

🔺 Lite 变体支持了 --vo=gpu

相关列表： Artoriuz-cfl + Artoriuz-bilateral + Artoriuz-pixelclipper

CfL_Prediction.glsl

FastBilateral_next.glsl
JointBilateral_next.glsl
MemeBilateral_next.glsl

PixelClipper.glsl
相关列表（MOD）： deus0ww-bilateral

CfL_Prediction_Lite.glsl
MemeBilateral_Lite.glsl
☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲

FSRCNNX
由原始SRCNN发展而来，是FSRCNN的变体，较快速的通用型AI放大算法。

🔺 启用将覆盖 mpv.conf 中指定的 --scale=xxxxx 算法
🔺 最小缩放触发倍率为1.2

LineArt 和 anime 变体更适合2d动画； enhance 变体在去除伪影强度上更大； 1x 变体不执行放大

副作用： 16_0_4_1 变体用更多的能耗（更慢）换取更好的质量，但感知较弱。

相关列表：igv-FSRCNN

FSRCNNX_x2_8_0_4_1.glsl
FSRCNNX_x2_8_0_4_1_LineArt.glsl
FSRCNNX_x2_16_0_4_1.glsl
相关列表：HelpSeeker-FSRCNN

FSRCNNX_x1_16_0_4_1_anime_distort.glsl
FSRCNNX_x1_16_0_4_1_distort.glsl
FSRCNNX_x2_16_0_4_1_anime_distort.glsl
FSRCNNX_x2_16_0_4_1_distort.glsl
☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲

AviSynth AiUpscale
名字奇怪是因为开发者主要移植到AviSynth+上用的，和FSRCNNX有相似的体系结构，但使用了不同的滤镜。

x2 x3 x4 分别对应 二倍 三倍 四倍 放大
质量上 Fast 弱于 Medium 弱于 HQ
性能需求上 Fast2x 介于 FSRCNNX8 和 FSRCNNX16 之间， 但是 Medium2x 远高于 FSRCNNX16， 变体 HQ 因速度极慢而难以用于高质量片源
LineArt 适合2D画面而 Photo 适合现实类画面

🔺 启用将覆盖 mpv.conf 中指定的 --scale=xxxxx 算法
🔺 不同倍率对应的最小缩放触发倍率分别为1.2 2.2 3.2

相关列表：（已省略3x和4x的类似名变体）Alexkral-hooks

AiUpscale_Fast_2x_LineArt.glsl
AiUpscale_Fast_2x_Photo.glsl
AiUpscale_Fast_Sharp_2x_LineArt.glsl
AiUpscale_Fast_Sharp_2x_Photo.glsl
AiUpscale_Medium_2x_LineArt.glsl
AiUpscale_Medium_2x_Photo.glsl
AiUpscale_Medium_Sharp_2x_LineArt.glsl
AiUpscale_Medium_Sharp_2x_Photo.glsl
AiUpscale_HQ_2x_LineArt.glsl
AiUpscale_HQ_2x_Photo.glsl
AiUpscale_HQ_Sharp_2x_LineArt.glsl
AiUpscale_HQ_Sharp_2x_Photo.glsl
...
☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲

Adaptive Sharpen
自适应锐化

变体 best 理论上拥有最佳质量但强度较低；
变体 luma 只处理亮度通道不适合rgb源

Krig
利用亮度信息进行高质量的色度升频
mpv目前最好的色度升频着色器，可以与其他缩放（ --scale/dscale ）算法共同使用

🔺 启用将覆盖 mpv.conf 中指定的 --cscale=xxxxx 算法

SSimSuperRes
该着色器的目的是对mpv内置 --scale=xxxxx 放大算法进行增强校正。

SSimDownscaler
基于感知的对mpv内置 --dscale=xxxxx 缩小算法进行增强校正。（例如抗振铃）

以上四项及FSRCNNX皆由同一开发者移植

相关列表：igv-hooks

adaptive_sharpen.glsl

KrigBilateral.glsl

SSimDownscaler.glsl
SSimSuperRes.glsl
相关列表：MOD （变体 luma 仅作用于亮度通道）

adaptive_sharpen_luma.glsl
☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲

RAVU
(Rapid and Accurate Video Upscaling)是一组受RAISR（快速准确的图像超分辨率）启发的预分频着色器。
它具有不同的变体以适应不同的场景。 RAVU整体的性能消耗设计上比mpv内置的ewa系缩放器高。

NNEDI3
全称Neural Network Edge Directed Interpolation，是一种超高质量的插值放大算法。
nnedi3版速度较快（即便如此相比其它算法，依旧速度极慢且开销巨大）

SuperXBR
一个经典的擅长整数倍放大算法，消耗介于NNEDI3和RAVU之间。

以上三项由同一开发者移植，在项目中提供了更多说明： bjin-hooks

r2 → r3 → r4；
nns16 → nns32 → nns64 → nns128 → nns256；
win8x4 → win8x6
质量更好但性能大增

开发者仓库的 compute 文件夹内（需要的显卡支持的OpenGL版本≥4.3）的版本比 gather 目录内的（OpenGL≥4.0）更快，后者比 主目录下的 master 的更快。

3x 变体直接放大三倍，适用于超低清源； ar 变体自带抗振铃处理。
无其它后缀的和 3x 变体的训练模型为动漫， lite 和 zoom 变体为通用模型。

🔺 变体 ddx 专用于 --vo=gpu --gpu-context=d3d11 （但不支持 --vo=gpu --gpu-context=win ），其它变体可在 --vo=gpu-next 下任意后端使用。
🔺 除了 chroma 变体（启用将覆盖 mpv.conf 中指定的 --cscale=xxxxx 算法），其它只处理(YUV)luma通道（启用将覆盖 mpv.conf 中指定的 --scale=xxxxx 算法）
🔺 lite 变体最快最锐利但无半像素偏移，可能产生锯齿和晕轮/振铃。 rgb 和 yuv 变体在 --cscale 执行完之后开始作用，但 yuv 变体无法处理RGB的源（例如PNG图片）
🔺 关于半像素偏移，除了 lite 和 chroma 变体，其它ravu和nnedi3和sxbr中都存在。可以用 mpv.conf 中的 --scaler-resizes-only=no 修正它，但是没必要（感知不强）

🔺 sxbr没有触发倍率限制；
无其它后缀的和 lite 变体的最小缩放触发倍率约为1.2， 3x 变体最小缩放触发倍率约为2.2。 zoom 变体直接放大到目标分辨率，触发倍率＞1；
nnedi3最小缩放触发倍率约为1.2，对性能要求很高（临时加载可能导致假死）， nns128 级别以上的因速度很慢而很难即时观看时使用。

仓库主分支内精简并保留的部分列表（已统一修改后缀格式名为glsl）：
来自 compute 目录

ravu_3x_r2.glsl
ravu_3x_r2_rgb.glsl
ravu_3x_r2_yuv.glsl
ravu_3x_r3.glsl
ravu_3x_r3_rgb.glsl
ravu_3x_r3_yuv.glsl
ravu_3x_r4.glsl
ravu_3x_r4_rgb.glsl
ravu_3x_r4_yuv.glsl
ravu_lite_r2.glsl
ravu_lite_r3.glsl
ravu_lite_r4.glsl
ravu_lite_ar_r2.glsl
ravu_lite_ar_r3.glsl
ravu_lite_ar_r4.glsl
ravu_r2.glsl
ravu_r2_rgb.glsl
ravu_r2_yuv.glsl
ravu_r3.glsl
ravu_r3_rgb.glsl
ravu_r3_yuv.glsl
ravu_r4.glsl
ravu_r4_rgb.glsl
ravu_r4_yuv.glsl
ravu_zoom_r2.glsl
ravu_zoom_r2_chroma.glsl
ravu_zoom_r2_rgb.glsl
ravu_zoom_r2_yuv.glsl
ravu_zoom_r3.glsl
ravu_zoom_r3_chroma.glsl
ravu_zoom_r3_rgb.glsl
ravu_zoom_r3_yuv.glsl
ravu_zoom_ar_r2.glsl
ravu_zoom_ar_r2_rgb.glsl
ravu_zoom_ar_r2_yuv.glsl
ravu_zoom_ar_r3.glsl
ravu_zoom_ar_r3_rgb.glsl
ravu_zoom_ar_r3_yuv.glsl

nnedi3_nns16_win8x4.glsl
nnedi3_nns16_win8x6.glsl
nnedi3_nns32_win8x4.glsl
nnedi3_nns32_win8x6.glsl
nnedi3_nns64_win8x4.glsl
nnedi3_nns64_win8x6.glsl
nnedi3_nns128_win8x4.glsl
nnedi3_nns128_win8x6.glsl
nnedi3_nns256_win8x4.glsl
nnedi3_nns256_win8x6.glsl
来自 主目录

superxbr.glsl
superxbr_rgb.glsl
superxbr_yuv.glsl
来自 rgba16hf 分支

ravu_3x_r2_ddx.glsl
ravu_3x_r2_rgb_ddx.glsl
ravu_3x_r2_yuv_ddx.glsl
ravu_3x_r3_ddx.glsl
ravu_3x_r3_rgb_ddx.glsl
ravu_3x_r3_yuv_ddx.glsl
ravu_3x_r4_ddx.glsl
ravu_3x_r4_rgb_ddx.glsl
ravu_3x_r4_yuv_ddx.glsl
ravu_lite_r2_ddx.glsl
ravu_lite_r3_ddx.glsl
ravu_lite_r4_ddx.glsl
ravu_lite_ar_r2_ddx.glsl
ravu_lite_ar_r3_ddx.glsl
ravu_lite_ar_r4_ddx.glsl
ravu_r2_ddx.glsl
ravu_r2_rgb_ddx.glsl
ravu_r2_yuv_ddx.glsl
ravu_r3_ddx.glsl
ravu_r3_rgb_ddx.glsl
ravu_r3_yuv_ddx.glsl
ravu_r4_ddx.glsl
ravu_r4_rgb_ddx.glsl
ravu_r4_yuv_ddx.glsl
ravu_zoom_r2_chroma_ddx.glsl
ravu_zoom_r2_ddx.glsl
ravu_zoom_r2_rgb_ddx.glsl
ravu_zoom_r2_yuv_ddx.glsl
ravu_zoom_r3_chroma_ddx.glsl
ravu_zoom_r3_ddx.glsl
ravu_zoom_r3_rgb_ddx.glsl
ravu_zoom_r3_yuv_ddx.glsl
ravu_zoom_ar_r2_ddx.glsl
ravu_zoom_ar_r2_rgb_ddx.glsl
ravu_zoom_ar_r2_yuv_ddx.glsl
ravu_zoom_ar_r3_ddx.glsl
ravu_zoom_ar_r3_rgb_ddx.glsl
ravu_zoom_ar_r3_yuv_ddx.glsl
☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲

AMD-CAS
移植自AMD FidelityFX CAS (Contrast Adaptive Sharpening)，原始设计用于游戏，对比度自适应锐化是一种低开销的锐化算法。

🔺 rgb 变体作用于后处理，比常规版本开销微高，速度微慢

AMD-FSR
移植自AMD FidelityFX Super Resolution (FSR)，原始设计用于游戏，是一种先执行常规放大后再进行对比度自适应锐化的改良算法。放大部分基于lanczos+bilinear，锐化部分基于cas

相关列表：agyild-fsr & agyild-cas
（变体 scaled 功能完整，附带了缩放模块而非纯粹的锐化算法）

AMD_CAS.glsl
AMD_CAS_scaled.glsl
AMD_FSR.glsl
相关列表：MOD
（变体 luma rgb 没有放大倍率的上限；变体 EASU 分离自fsr的放大模块，用作纯粹的放大算法）

AMD_CAS_rgb.glsl
AMD_CAS_scaled_rgb.glsl
AMD_FSR_rgb.glsl
AMD_FSR_EASU_luma.glsl
AMD_FSR_EASU_rgb.glsl
相关列表：deus0ww-cas & kevinlekiller-cas
（其它人移植的精简cas功能后的版本，更快速和低耗）

AMD_CAS_lite_luma.glsl
AMD_CAS_lite_rgb.glsl
AMD_CAS_lite2_rgb.glsl
🔺 变体 luma 和无其它后缀名的版本都只作用于亮度通道（预处理）

☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲

NV-NIS
移植自NVIDIA Image Scaling (NIS)，原始设计用于游戏，是一种基于lanczos的常规放大算法，并辅以自适应锐化改变观感。

🔺 此算法的振铃伪影异常明显，并且会随着锐化强度的增加而愈发显著

NV-NVSharpen
移植自NIS中的锐化模块，原始设计用于游戏。

相关列表：agyild-nis

NVScaler.glsl
NVSharpen.glsl
相关列表：MOD （变体 rgb 作用于后处理，比常规版本开销微高，速度微慢）

NVScaler_rgb.glsl
NVSharpen_rgb.glsl
🔺无后缀名的版本都只作用于亮度通道（预处理）

☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲

guided
快速降噪。

相关列表（精简）：

guided.glsl
guided_fast.glsl
guided_s.glsl
hdeband
高质量去色带。

相关列表（精简）：

hdeband.glsl
NL Means
移植自FFmpeg的nlmeans滤镜。非局部均值降噪

以上三项由同一开发者移植，在项目中提供了更多说明AN3223-nlmeans

相关列表（精简）：

nlmeans.glsl
nlmeans_lq.glsl
nlmeans_temporal.glsl
相关列表：MOD （变体 dx 用于避免 --gpu-context=d3d11 下运行时的冻结问题）

nlmeans_dx.glsl
nlmeans_lq_dx.glsl
nlmeans_temporal_dx.glsl
作者仓库存在大量其它变体，但几乎只是预设参数不同的区别。

🔺变体 temporal 只能在 --vo=gpu-next 下使用（可利用时域信息进行处理）

☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲

Noise Static
优化静态的色度/亮度噪点。

🔺 需要 mpv.conf 中设置为 --deband-grain=0 的前提下使用

相关列表：pastebin-hook1 & pastebin-hook2

noise_static_chroma.glsl
noise_static_luma.glsl
☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲☲

其它
相关列表：
来源非全部可查
garamond13-hooks
Tsubajashi-hooks
voltmtr-lumasharpen

## 实际工作顺序[](https://hooke007.github.io/unofficial/mpv_shaders.html#id5 "此标题的永久链接")

着色器按工作插入位置可大致分为“预处理”与“后处理”两类，此由着色器本身决定，无法被设置文件更改。（在统计信息的第二页可直观查看）

如图，以 combining planes 为大致的分界线 —— 之前的步骤为预处理， `--cscale=xxxxx` 也在此处（图中被krig替换）。之后的步骤为后处理， `--scale/dscale=xxxxx` 也在此处。

[![stats_01](https://hooke007.github.io/_images/mpv_shaders-stats_01.webp)](https://hooke007.github.io/_images/mpv_shaders-stats_01.webp)

因此，着色器的实际工作顺序，首选遵守该原则，其次才是用户指定的顺序。（此外在同为预处理与后处理类的着色器之中也有顺序限制，具体请自行测试）

- 预处理： 所有 luma、 chroma 变体； ACNet FSRCNNX AiU Krig RAVU NNEDI3 SXBR CAS NoiseS minblur_usm
    
- 后处理： 所有 yuv、 rgb 变体； A4k Anime4K_legacy_09 SSDS SSSR Adaptive colorlevel saturate unsharp unsharp_masking_next
    
- 混合： Anime4K_legacy_10
    

🔺 （此处未完整列出全部着色器）

## 叠加放大类着色器的注意点[](https://hooke007.github.io/unofficial/mpv_shaders.html#id6 "此标题的永久链接")

前一节已经讲了着色器加载顺序上的一些逻辑，这里补充放大类着色器的专属问题。

不同的放大类着色器对原尺寸的定义不同：  
直觉认知里，1080p的视频不管怎么拉伸，源的原尺寸始终是1080p。符合这一逻辑的是Anime4k中的 Original 变体  
反直觉的是，经过上一级着色器放大后的源大小变成了放大后的尺寸。符合这一逻辑的是Anime4k中的其它放大类变体，以及大多数放大类着色器

例一：在1440p显示器上打开一个1080p视频全屏，此时你（只要性能足够）可以无限叠加n个 `Anime4K_Upscale_Original_x2.glsl` 无障碍实现2^n倍放大。  
例二：同上的硬件环境，720p的视频先调用了nnedi3再调用fsrcnnx进行二次放大，你可能发现无法真实触发后者，原因在于720p的视频经过nnedi3第一次放大后被后方加载的fsrcnnx认为源是(720x2=)1440p，此时2k的显示器在全屏模式的分辨率并不满足fsrcnnx的最小放大触发倍率(1.3)

## 通过快捷键动态启用与禁用[](https://hooke007.github.io/unofficial/mpv_shaders.html#id7 "此标题的永久链接")

适用于 **input.conf**  
语法结构：  
`键位(组合)名   change-list glsl-shaders (不带符号"-"的)后缀   着色器文件名(可多项，用半角符号";"分隔)`

[《string-list-and-path-list-options》](https://mpv.io/manual/master/#string-list-and-path-list-options)

|可用后缀|说明（不推荐的语法可能在将来被弃用）|
|---|---|
|-set|设置着色器列表为一个或多个着色器（使用 `;` 分隔多个着色器，使用 `\` 作为转义符）|
|-append|追加一个着色器到着色器列表的后方|
|-add|追加一个或多个着色器到着色器列表的后方 (同 `-set` 的注意点)|
|-pre|增加一个或多个着色器到着色器列表的前方 (同 `-set` 的注意点)|
|-clr|清空着色器列表|
|-remove|移除一个列表中已存在的着色器|
|-toggle|追加一个着色器到着色器列表的后方，如果已存在则移除它|

支持使用mpv的相对路径（比如 `~~/` 指向主设置文件夹）  
例如：

CTRL+1 change-list glsl-shaders set "~~/shaders/KrigBilateral.glsl;~~/shaders/ravu_zoom_r3.glsl;~~/shaders/AMD_CAS_lite_luma.glsl"

其它示例可参考仓库内 [**input.conf**](https://github.com/hooke007/MPV_lazy/blob/main/portable_config/input_list.conf) 的“着色器列表”部分。

## 速度的对比参考[](https://hooke007.github.io/unofficial/mpv_shaders.html#id8 "此标题的永久链接")

🔺 （此节的信息已过时。我对部分着色器的跑分测试参见 [此处](https://github.com/hooke007/MPV_lazy/discussions/255#discussioncomment-4685344)）

使用个别着色器进行两倍放大，计算每秒所能生成的最大帧数。数值越大说明速度越快，越适合实际观看时使用，数值低于视频原始帧率即完全不可用。  
实际速度**极大**取决于视频的质量、缩放倍率和你的显卡性能，因此两表中同一个 fsrcnnx16 的性能结果差异不符合常理也不奇怪，数据仅供大概参考。

_数据来源 GitHub@Alexkral(NVIDIA GTX 1080)_

|着 色 器|mpv 2x : 1080p → 2160p|
|---|---|
|A4k M|407|
|A4k L|287|
|FSRCNNX 8|256|
|AiU Fast|145|
|FSRCNNX 16|93|
|A4k UL|75|
|AiU M|51|
|AiU HQ|26|

_数据来源 GitHub@Artoriuz_

|算法&着色器|mpv 2x : 720p → 1440p|
|---|---|
|bilinear|468|
|spline36|383|
|ewa_lanczossharp|338|
|RAVU lite r4|307|
|RAVU r4|238|
|NNEDI3 16 8x4|210|
|SSSR|169|
|NNEDI3 32 8x4|156|
|RAVU zoom r4|138|
|NNEDI3 64 8x4|99|
|NNEDI3 128 8x4|55|
|FSRCNNX 16|52|
|NNEDI3 256 8x4|30|


具体全文参考：

https://hooke007.github.io/unofficial/mpv_shaders.html

**仅供参考，部分已经过时**

