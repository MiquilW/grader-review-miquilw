CPATH='.;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar'

rm -rf student-submission
git clone $1 student-submission
echo 'Finished cloning'

cd student-submission

if [[ -f ListExamples.java ]]
then
    echo "ListExamples found"
else
    echo "need file ListExamples.java"
    exit 1
fi

cp ../TestListExamples.java ./

mkdir lib

cp ../lib/hamcrest-core-1.3.jar ./lib
cp ../lib/junit-4.13.2.jar ./lib

javac -cp $CPATH *.java

if [ $? -ne 0 ]
then
    echo "Compiler Error"
    exit 1
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > junit-results.txt

grep "FAILURES!!!" junit-results.txt > results.txt

RESULTS=`cat results.txt`

if [ $RESULTS ]
then
    if [ $RESULTS == "FAILURES!!!" ]
    then
        echo "You failed, try again."
        exit 1
    fi
else
    echo "You passed! Great job."
fi
