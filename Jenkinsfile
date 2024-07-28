pipeline
{
    agent any
    stages
    {
        stage("Cleaning the workspace")
        {
            steps
            {
                script
                {
                    def workspaceDir = "/var/lib/jenkins/workspace/automation-wisecow/"
                    if (fileExists(workspaceDir))
                    {
                        sh "sudo rm -rf ${workspaceDir}*"
                        echo "Workspace directory cleared, Ready to Run."
                    }
                    else 
                    {
                        echo "Workspace directory doesn't exist."
                    }
                }
            }
        }
        stage("Cloning the repository")
        {
            steps
            {
                withCredentials([usernamePassword(credentialsId: 'GITHUB-ID', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD')])
                {
                    sh '''sudo git clone https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/RameshXT/WISECOW-DEPLOYMENT.git -b wisecow'''
                    echo "The WISECOW-DEPLOYMENT was cloned successfully"
                }
            }
        }
        stage("Building dockerfile")
        {
            steps
            {
                    script
                    {
                        def dockerImageTag = "rameshxt/wisecow-d:${BUILD_NUMBER}"
                        sh "sudo docker build -t ${dockerImageTag} /var/lib/jenkins/workspace/automation-wisecow/WISECOW-DEPLOYMENT"
                        echo "The Docker ${dockerImageTag} was successfully built"
                    }
                }
        }
        stage("Docker login")
        {
            steps
            {
                withCredentials([string(credentialsId: 'Docker-D', variable: 'Dockerlogin')])
                {
                    sh '''echo "$Dockerlogin" | sudo docker login -u rameshxt --password-stdin'''
                    echo "Logged into DockerHub successfully"
                } 
            }
        }
        stage("Pushing image to dockerHUB")
        {
            steps
            {
                script
                {
                    def dockerImageTag = "rameshxt/wisecow-d:${BUILD_NUMBER}"
                    sh "sudo docker push ${dockerImageTag}"
                    echo "Docker images ${dockerImageTag} pushed into Docker Hub successfully"
                }
            }
        }
        stage("Deleting image")
        {
            steps
            {
                script
                {
                    def images = sh(script: "sudo docker images -q", returnStdout: true).trim().split('\n')
                    if (images[0])
                    {
                        sh "sudo docker rmi -f ${images.join(' ')}"
                        echo "Images were deleted successfully"
                    }
                    else
                    {
                        echo "No images are there to delete!!"
                    }
                }
            }
        }  
    }
}