#setting up the environment.
. cico_setup.sh

# installing eslint tool.
npm install eslint --save-dev

eslint --config ./.eslintrc.json --ignore-path ./.eslintignore .

if [ $? -eq 0 ]
then
    echo "All checks passed"
else
    echo "Linter fail, source files need to be fixed"
    exit 1
fi