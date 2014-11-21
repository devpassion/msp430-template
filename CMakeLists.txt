cmake_minimum_required(VERSION 2.8)
project(msp430_template)
 
find_package(KDE4 REQUIRED)
find_package(KDevPlatform REQUIRED)
 
set(TEMPLATE_DIRS msp430-template)
kdevplatform_add_app_templates(${TEMPLATE_DIRS})

