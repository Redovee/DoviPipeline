# DoviPipeline
基于Unity SRP的玩具级渲染管线开发，用于个人学习研究

目前包含的主要内容包括：  
基础管线：支持SRP Batching，支持多种光源（平行光、聚光灯、点光源）、多个光源（最多4盏）。  
简单光照明模型：Lambert、Half Lambert、Phong、Blinn-Phong，并应用多种光源多个光源。  
PBR材质：Cook-Torrance微表面简单模型，基于IBL和BRDF实现PBR光照。  
延迟渲染、软光栅全局光照：VXGI，参照Looooong的项目，主要用以学习思路和熟悉SRP、Compute Shader。  
体积光：基于Ray Marching的体积光实现，参照SlightlyMad的项目。  
后处理：X-PostProcessing-Library

refenrence:  
https://github.com/Kirkice/SRPTest  
https://github.com/QianMo/X-PostProcessing-Library  
https://github.com/Looooong/Unity-SRP-VXGI  
https://github.com/SlightlyMad/VolumetricLights  
