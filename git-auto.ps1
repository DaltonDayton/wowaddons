# git-auto.ps1
$time = Get-Date -Format "dd MMM yy - HH:mm:ss"
git add .
git commit -m "$time"
git push
