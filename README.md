<h1>CCT Code Assignment</h1>

- Where possible security is restricted based on known information in the assignment.
- The tasks are broken into logical files for re-use.
- Scalability is built-in to the ECS Task with Variables for Scaling manually.
- I kept this task timed at 1 hour.
- NACLs weren't necessary within the confines of the assignment and security groups were sufficient for the brevity of the task.
- I did not include secrets becuase in an IAM identity based scenario, tokens and sts are best practices for applying AWS infrastructure changes.

<h3> Suggested Iterations </h3>
- Create IAM Execution Role/Policy with attachments
- Create Cloudwatch Metric Alarm for Container Utilization
- Create Autoscaling Policy
- Create a Launch Configuration