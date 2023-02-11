#!/bin/sh

#  release_pod.sh
#  JYMediator
#
#  Created by crazyball on 2023/2/12.
#  Copyright © 2023 CocoaPods. All rights reserved.



project=$1
currentTag=$2
podRepo="JYPodRepo"
podRepoUrl="https://github.com/crazyball666/JYPodRepo.git"


echo "Pod 发版"
echo "project: ${project}"
echo "tag: ${currentTag}"
echo "repo: ${podRepo}"
echo "repoUrl: ${podRepoUrl}"


# 根据头文件版本号。重写 podspec 文件中的版本号
podspecVersionCodeWrite() {
    ##获取podspec中需要填入版本号的位置
    local podspecFilePath=`find . -name ${project}.podspec` || exit
    #获取 s.verion所在行以及内容
    local podspecVersionTarget=`grep -n "s.version" ${podspecFilePath} | head -1`
    #获取所在行内容
    local targetcontent=${podspecVersionTarget#*:}
    #截取版本号
    local targetversion=${targetcontent#*=}
    echo oldversion${targetversion}
    #获取所在行行号
    local targetline=${podspecVersionTarget%:*}
    
    #替换podspec中版本号
    local str="  s.version          = '${currentTag}'"
    sed -i "" "${targetline}s/${targetcontent}/${str}/g" ${podspecFilePath}
}

#发布 Podspec
uploadPodspec() {
    pod repo push --skip-import-validation --allow-warnings --verbose "${podRepo}" "${project}.podspec" || exit
}

# 执行 pod repo
podspecVersionCodeWrite

uploadPodspec || exit
