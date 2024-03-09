# Hello There!
If you have somehow stumbled upon this project, you will bear witness to the creation of a simple Terraform project for the creation of a miniature pipeline in AWS.

The goal here? To have some fun and get some hands on experience with the usage of Terraform of course!

## AWS Services
The following are some of the services that will be used within the pipeline. The overall architecture will be added soon.

### S3
The primary means of storage for this project. The ingestion bucket will be setup to send an S3 PUT event message to an SQS queue.

### SQS
The choice of trigger for this project. An SQS queue will be setup to receive S3 PUT event messages that will then be used to trigger Lambda. A dead letter queue will be setup alongside this queue as a means to retrieve any failed messages that could not be processed by Lambda.

Mainly a means to decouple the rate of firing off Lambdas (well Lambda does have throttling but I prefer having an SQS queue in place given how it can not only help me queue stuff, but also send it to a DLQ for inspection. Not to mention the ability to retrigger the process via DLQ Redrive)

### Lambda
The compute resource that will do some simple processing of the given file. Retrieves information on the S3 object via SQS message, and then outputs it to some output S3 bucket (well technically we can use the same bucket and separate em via prefixes. important to make sure the S3 PUT events are specified to use the correct prefix for when sending the message to SQS, if not an infinite loop will occur). 
