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

num_passed=$(sed -n '2!p' junit-results.txt | grep -c -m 1 ".")
num_failed=$(sed -n '2!p' junit-results.txt | grep -c -m 1 "E")

total_tests=$((num_passed + num_failed))

grade=$((num_passed * 100 / total_tests))

if [[ "$num_failed" -eq 0 ]]; then
    echo "Congratulations, all $total_tests test(s) passed! Your grade is $grade%."
else
    echo "Some tests failed ($num_failed out of $total_tests). Your grade is $grade%."
fi
