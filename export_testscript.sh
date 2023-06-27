#!/bin/bash

estatus=0

cmdPath='./gcscmd'

testCases() {

  echo "_/_/_/_/_/_/_/_/_/_/_/_/_/ 导出car文件 开始 _/_/_/_/_/_/_/_/_/_/_/_/_/"
  echo '导出 car 文件 => 根据cid下载 => cid正确下载 => gcscmd get cs://bbb --cid QmWgnG7pPjG31w328hZyALQ2BgW5aQrZyKpT47jVpn8CNo start'
  echo '数据准备'
  echo '1、创建新桶'
  bucketName="bucket-export-"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  $cmdPath mb cs://$bucketName
  echo '2、添加目录'
  # root folder
  testRootDataFolderName="testRootFolder_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  #echo $testRootDataFolderName
  # child folders
  testChildDataFolderName1="testChildFolder_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  testChildDataFolderName2="testChildFolder_2_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  #echo $testChildDataFolderName1
  #echo $testChildDataFolderName2
  # grandchild folders
  testGrandchildDataFolderName1="testGrandchildFolder_2_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  testGrandchildDataFolderName2="testGrandchildFolder_2_2_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  testGrandchildDataFolderName3="testGrandchildFolder_2_3_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  #echo $testGrandchildDataFolderName1
  #echo $testGrandchildDataFolderName2
  #echo $testGrandchildDataFolderName3
  # grandchild folder path
  testGrandchildDataFolderPath1=$testRootDataFolderName'/'$testChildDataFolderName2'/'$testGrandchildDataFolderName1
  testGrandchildDataFolderPath2=$testRootDataFolderName'/'$testChildDataFolderName2'/'$testGrandchildDataFolderName2
  testGrandchildDataFolderPath3=$testRootDataFolderName'/'$testChildDataFolderName2'/'$testGrandchildDataFolderName3
  mkdir -p $testGrandchildDataFolderPath1
  mkdir -p $testGrandchildDataFolderPath2
  mkdir -p $testGrandchildDataFolderPath3
  mkdir -p $testRootDataFolderName'/'$testChildDataFolderName1
  #  $cmdPath put $testRootDataFolderName cs://$bucketName
  echo '3、添加对象'
  # add files in grandchild folders
  testDataFileName="testdata_2_1_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testGrandchildDataFolderPath1'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_2_1_2_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testGrandchildDataFolderPath1'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_2_2_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testGrandchildDataFolderPath2'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_2_2_2_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testGrandchildDataFolderPath2'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_2_3_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testGrandchildDataFolderPath3'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  # add files in child folders
  testDataFileName="testdata_1_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testRootDataFolderName'/'$testChildDataFolderName1'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_2_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testRootDataFolderName'/'$testChildDataFolderName2'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_2_2_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testRootDataFolderName'/'$testChildDataFolderName2'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  # add files in root folder
  testDataFileName="testdata_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testRootDataFolderName'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_2_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testRootDataFolderName'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_3_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testRootDataFolderName'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  echo '4、生成CAR文件(测试环境需要安装car命令行程序)'
  carFilename=$testRootDataFolderName'.car'
  car c --version 1 -f $carFilename $testRootDataFolderName
  dataPath=$carFilename
  # import car file
  resp=$($cmdPath import $dataPath cs://$bucketName)
  #  echo $resp
  echo '5、获取CID'
  cid=$(echo "$resp" | awk '/CID:/{print $2}')
  echo '6、数据清理'
  rm -rf $testRootDataFolderName
  rm -rf $dataPath

  execCmd '导出对象' '根据cid下载' 'cid正确下载' 'gcscmd get cs://'$bucketName' --cid '$cid 'get cs://'$bucketName' --cid '$cid ''
  echo '7、数据清理'
  rm -rf $testRootDataFolderName

  echo '导出 car 文件 => 根据cid下载 => cid正确下载 => gcscmd get cs://bbb --cid QmWgnG7pPjG31w328hZyALQ2BgW5aQrZyKpT47jVpn8CNo end'
  echo ''

  echo '导出 car 文件 => 根据对象名下载 => 对象名正确下载 => gcscmd get cs://bbb --name folder start'
  echo '数据准备'
  echo '1、添加目录'
  # root folder
  testRootDataFolderName="testRootFolder_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  #echo $testRootDataFolderName
  # child folders
  testChildDataFolderName1="testChildFolder_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  testChildDataFolderName2="testChildFolder_2_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  #echo $testChildDataFolderName1
  #echo $testChildDataFolderName2
  # grandchild folders
  testGrandchildDataFolderName1="testGrandchildFolder_2_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  testGrandchildDataFolderName2="testGrandchildFolder_2_2_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  testGrandchildDataFolderName3="testGrandchildFolder_2_3_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  #echo $testGrandchildDataFolderName1
  #echo $testGrandchildDataFolderName2
  #echo $testGrandchildDataFolderName3
  # grandchild folder path
  testGrandchildDataFolderPath1=$testRootDataFolderName'/'$testChildDataFolderName2'/'$testGrandchildDataFolderName1
  testGrandchildDataFolderPath2=$testRootDataFolderName'/'$testChildDataFolderName2'/'$testGrandchildDataFolderName2
  testGrandchildDataFolderPath3=$testRootDataFolderName'/'$testChildDataFolderName2'/'$testGrandchildDataFolderName3
  mkdir -p $testGrandchildDataFolderPath1
  mkdir -p $testGrandchildDataFolderPath2
  mkdir -p $testGrandchildDataFolderPath3
  mkdir -p $testRootDataFolderName'/'$testChildDataFolderName1
  #  $cmdPath put $testRootDataFolderName cs://$bucketName
  echo '2、添加对象'
  # add files in grandchild folders
  testDataFileName="testdata_2_1_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testGrandchildDataFolderPath1'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_2_1_2_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testGrandchildDataFolderPath1'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_2_2_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testGrandchildDataFolderPath2'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_2_2_2_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testGrandchildDataFolderPath2'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_2_3_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testGrandchildDataFolderPath3'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  # add files in child folders
  testDataFileName="testdata_1_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testRootDataFolderName'/'$testChildDataFolderName1'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_2_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testRootDataFolderName'/'$testChildDataFolderName2'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_2_2_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testRootDataFolderName'/'$testChildDataFolderName2'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  # add files in root folder
  testDataFileName="testdata_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testRootDataFolderName'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_2_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testRootDataFolderName'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_3_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testRootDataFolderName'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  echo '3、生成CAR文件(测试环境需要安装car命令行程序)'
  carFilename=$testRootDataFolderName'.car'
  car c --version 1 -f $carFilename $testRootDataFolderName
  dataPath=$carFilename
  # import car file
  resp=$($cmdPath import $dataPath cs://$bucketName)
  #  echo $resp
  echo '4、获取CID'
  cid=$(echo "$resp" | awk '/CID:/{print $2}')
  echo '5、数据清理'
  rm -rf $testRootDataFolderName
  rm -rf $dataPath

  # 设置对象名称
  #  objectName=$carFilename
  objectName=$testRootDataFolderName
  execCmd '导出对象' '根据对象名下载' '对象名正确下载' 'gcscmd get cs://'$bucketName' --name '$objectName 'get cs://'$bucketName' --name '$objectName ''
  echo '6、数据清理'
  rm -rf $testRootDataFolderName

  echo '导出 car 文件 => 根据对象名下载 => 对象名正确下载 => gcscmd get cs://bbb --name folder end'
  echo ''

  echo '导出car文件测试数据清理'
  $cmdPath rb cs://$bucketName --force
  #  rm -rf $testDataFileName
  echo "_/_/_/_/_/_/_/_/_/_/_/_/_/ 导出car文件 结束 _/_/_/_/_/_/_/_/_/_/_/_/_/"
  echo ''
}

execCmd() {
  testModule=$1
  testFunction=$2
  testCase=$3
  testDescription=$4
  testCmd=$5
  testExpectation=$6
  testFail=$7

  #  echo $testModule"=>"$testFunction"=>"$testCase"=>"$testDescription
  cmdStr=$cmdPath' '$testCmd
  echo 'executing '$cmdStr
  eval $cmdStr

  exitCode=$?
  echo ''
  if [ $exitCode -eq 0 ]; then
    echo -e "\033[32mSuccess: $cmdStr test pass. \033[0m"
  else
    echo -e "\033[31mFailure: $cmdStr test fail. \033[0m"
    estatus=$(($etatus + 1))
  fi

  echo "exitcode:"$exitCode
  echo ""
}

execCmdFail() {
  testModule=$1
  testFunction=$2
  testCase=$3
  testDescription=$4
  testCmd=$5
  testExpectation=$6
  testFail=$7

  #  echo $testModule"=>"$testFunction"=>"$testCase"=>"$testDescription
  cmdStr=$cmdPath' '$testCmd
  echo 'executing '$cmdStr
  eval $cmdStr

  exitCode=$?
  echo ''
  if [ $exitCode -eq 0 ]; then
    echo -e "\033[31mFailure: $cmdStr test should be prompt error message. \033[0m"
    estatus=$(($etatus + 1))
  else
    echo -e "\033[32mSuccess: $cmdStr test pass, return error message and exit code is not equal zero. \033[0m"
  #  estatus=$?
  fi

  echo "exitcode:"$exitCode
  echo ""
}

echo "===========================Chainstorage cli Test start=========================="
echo ''

testCases

echo "===========================Chainstorage cli Test end============================="

echo "Test status code:"$estatus
exit $estatus
