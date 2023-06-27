#!/bin/bash

estatus=0

cmdPath='./gcscmd'

testCases() {

  echo "_/_/_/_/_/_/_/_/_/_/_/_/_/ 导入car文件 开始 _/_/_/_/_/_/_/_/_/_/_/_/_/"
  echo '导入 car 文件 => 正确导入car文件 => 当前目录导入 => gcscmd import ./aaa.car cs://bbb start'
  echo '数据准备'
  echo '1、创建新桶'
  bucketName="bucket-import-"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  $cmdPath mb cs://$bucketName
  echo '2、添加对象，10MB'
  testDataFileName="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dd if=/dev/urandom of=$testDataFileName bs=10240 count=1024
  echo '3、生成CAR文件(测试环境需要安装car命令行程序)'
  carFilename=$(echo ${testDataFileName/.dat/.car})
  car c --version 1 -f $carFilename $testDataFileName
  # 设置当前目录
  dataPath=''$carFilename
  execCmd '导入 car 文件' '正确导入car文件' '当前目录导入' 'gcscmd import '$dataPath' cs://'$bucketName 'import '$dataPath' cs://'$bucketName ''
  echo '4、数据清理'
  rm -rf $testDataFileName
  rm -rf $dataPath
  echo '导入 car 文件 => 正确导入car文件 => 当前目录导入 => gcscmd import ./aaa.car cs://bbb end'
  echo ''

  echo '导入 car 文件 => 正确导入car文件 => 绝对路径导入 => gcscmd import /home/pz/aaa.car cs://bbb start'
  echo '数据准备'
  echo '1、添加对象，10MB'
  testDataFileName="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  # 设置绝对路径
  dataPath=$(pwd)'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=10240 count=1024
  echo '2、生成CAR文件(测试环境需要安装car命令行程序)'
  carDataPath=$(echo ${dataPath/.dat/.car})
  car c --version 1 -f $carDataPath $dataPath
  execCmd '导入 car 文件' '正确导入car文件' '绝对路径导入' 'gcscmd import '$carDataPath' cs://'$bucketName 'import '$carDataPath' cs://'$bucketName ''
  echo '3、数据清理'
  rm -rf $dataPath
  rm -rf $carDataPath
  echo '导入 car 文件 => 正确导入car文件 => 绝对路径导入 => gcscmd import /home/pz/aaa.car cs://bbb end'
  echo ''

  echo '导入 car 文件 => 正确导入car文件 => 相对路径 => gcscmd import ../pz/aaa.car cs://bbb start'
  echo '数据准备'
  echo '1、添加对象，10MB'
  testDataFileName="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  # 设置相对路径
  dataPath='tmp/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=10240 count=1024
  echo '2、生成CAR文件(测试环境需要安装car命令行程序)'
  carDataPath=$(echo ${dataPath/.dat/.car})
  car c --version 1 -f $carDataPath $dataPath
  execCmd '导入 car 文件' '正确导入car文件' '相对路径' 'gcscmd import '$carDataPath' cs://'$bucketName 'import '$carDataPath' cs://'$bucketName ''
  echo '3、数据清理'
  rm -rf $dataPath
  rm -rf $carDataPath
  echo '导入 car 文件 => 正确导入car文件 => 相对路径 => gcscmd import ../pz/aaa.car cs://bbb end'
  echo ''

  echo '导入car文件测试数据清理'
  $cmdPath rb cs://$bucketName --force
  #  rm -rf $testDataFileName
  echo "_/_/_/_/_/_/_/_/_/_/_/_/_/ 导入car文件 结束 _/_/_/_/_/_/_/_/_/_/_/_/_/"
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
