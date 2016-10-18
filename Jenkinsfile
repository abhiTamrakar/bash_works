#!groovy

node('master'){

        def build_number = "${env.BUILD_NUMBER}"
        def job = env.JOB_NAME.split('/')
        def job_name = job[0]
        def branch_name = job[1]
	def git_branch_name = branch_name.replaceAll("%2F","/")
	def url_branch_name = git_branch_name.replaceAll("/","%252F")
        def environment_name = "ci"
        def error_url = "http://localhost:8080/job/${job_name}/job/${url_branch_name}/${build_number}/console"

        try
        {
		echo "checking branch: ${git_branch_name}"
                git branch: "${git_branch_name}", credentialsId: '', url: 'https://github.com/come2abhi/abhixcripts.git'
        }
        catch(Exception e)
        {
                println "Git Pull failed"
                mail bcc: '', body: "There was problem in pulling the code from git repository.DevOps team will look into it.\nFor more details go to : ${error_url} ", cc: 'abhishek.tamrakar08@gmail.com', charset: 'UTF-8', from: '', mimeType: 'text/plain', replyTo: '', subject: "Failed Git Pull Report- ${git_branch_name}", to: "abhishek.tamrakar08@gmail.com"
                sh "exit 1"
        }

        try
        {
		stage 'Checkout'
		checkout scm
				
		stage 'Build_Backend_Code'
                echo "Running: Build_Backend_Code"
                sh "echo $branch_name"
		sh "uname -a"
                echo "GGGGot it"
}
        catch(Exception e)
        {
                stage 'Email Notification'
                println "ERROR: Continuous Integration pipeline failed"
                sh "git log --after 1.days.ago|egrep -io '[a-z0-9\\-\\._@]++\\.[a-z0-9]{1,4}'|head -1 >lastAuthor"
		def lines = readFile("lastAuthor")
                println "Email notifications will be send to : ${lines}"
                mail bcc: '', body: "ILP code did not succesfully pass the build and unit-test jobs in the Continuous Integration pipeline.\nFor more details go to : ${error_url} ", cc: 'abhishek.tamrakar08@gmail.com', charset: 'UTF-8', from: '', mimeType: 'text/plain', replyTo: '', subject: "Failed Build Report- ${git_branch_name}", to: "${lines}"
                sh "exit 1"
        }
}
