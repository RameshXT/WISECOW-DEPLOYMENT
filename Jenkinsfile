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
                    def workspaceDir = "/var/lib/jenkins/workspace/wisecow/"
                    if (fileExists(workspaceDir))
                    {
                        sh "sudo rm -rf ${workspaceDir}*"
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
                sh "sudo git clone https://github.com/RameshXT/wisecow.git"
            }
        }
        stage("Deleting existing images and containers")
        {
            steps
            {
                script
                {
                    def containers = sh(script: "sudo docker ps -a -q", returnStdout: true).trim().split('\n')
                    
                    if (containers[0])
                    {
                        sh "sudo docker stop ${containers.join(' ')}"
                        sh "sudo docker rm -f ${containers.join(' ')}"
                        echo "Containers successfully deleted!!"
                    }
                    else
                    {
                        echo "No containers are there to delete!!"
                    }
                    
                    def images = sh(script: "sudo docker images -q", returnStdout: true).trim().split('\n')
                    
                    if (images[0])
                    {
                        sh "sudo docker rmi -f ${images.join(' ')}"
                        echo "Images successfully deleted!!"
                    }
                    else
                    {
                        echo "No images are there to delete!!"
                    }
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
                        
                        sh "sudo docker build -t ${dockerImageTag} /var/lib/jenkins/workspace/wisecow/wisecow"
                    }
                }
        }

        stage("Running docker images")
        {
            steps
            {
                script
                {
                    def dockerImageTag = "rameshxt/wisecow-d:${BUILD_NUMBER}"
                    
                    sh "sudo docker run -itd --name wisecowcont -p 4499:4499 ${dockerImageTag}"
                    
                    echo "Docker container 'wisecow' running successfully."
                }
            }
        }
        stage("Docker login")
        {
            steps
            {
                withCredentials([string(credentialsId: 'DockerId', variable: 'Docker')])
                {
                    sh '''echo "$Docker" | sudo docker login -u rameshxt --password-stdin'''
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
                    
                    echo "Docker image ${dockerImageTag} pushed to DockerHub successfully."
                }
            }
        }  
    }
}