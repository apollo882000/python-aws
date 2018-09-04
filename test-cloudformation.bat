aws cloudformation create-stack --stack-name test-lambda --template-body file://test-lambda.json
aws cloudformation wait stack-create-complete --stack-name test-lambda

aws cloudformation create-stack --stack-name test-s3destbucket --template-body file://test-s3destbucket.json
aws cloudformation wait stack-create-complete --stack-name test-s3destbucket
aws cloudformation create-stack --stack-name test-s3srcbucket --template-body file://test-s3srcbucket.json --parameters ParameterKey=mylambda,ParameterValue=arn:aws:lambda:ap-southeast-1:<aws account id>:function:201809-test-lambda
aws cloudformation wait stack-create-complete --stack-name test-s3srcbucket
aws cloudformation update-stack --stack-name test-s3srcbucket --template-body file://test-s3srcbucket-cfg.json --parameters ParameterKey=mylambda,ParameterValue=arn:aws:lambda:ap-southeast-1:<aws account id>:function:201809-test-lambda
aws cloudformation wait stack-update-complete --stack-name test-s3srcbucket