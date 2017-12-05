eslint --config ./.eslintrc.json .

if [ $? -eq 0 ]
then
    echo "All checks passed"
else
    echo "Linter fail, source files need to be fixed"
    exit 1
fi