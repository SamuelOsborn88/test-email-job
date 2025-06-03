# Log to send a test email
$logPath = "send-test-email.log"
Start-Transcript -Path $logPath -Append

# SMTP settings
$smtpServer = "smtp.office365.com"
$smtpPort = 587
$smtpUser = "samuel.osborn@anheuser-busch.com"  # Replace with your email
$smtpPassword = "${{ secrets.SMTP_PASSWORD }}"  # Stored in GitHub Secrets
$fromAddress = $smtpUser
$recipients = @("samuel.osborn@anheuser-busch.com")  # Replace with your recipient(s)
$subject = "Test Email from GitHub Actions"
$body = "Hello,<br><br>This is a test email sent from GitHub Actions.<br><br>Regards,<br>Your Name"

try {
    $mailParams = @{
        SmtpServer = $smtpServer
        Port = $smtpPort
        UseSsl = $true
        Credential = New-Object System.Management.Automation.PSCredential($smtpUser, (ConvertTo-SecureString $smtpPassword -AsPlainText -Force))
        From = $fromAddress
        To = $recipients
        Subject = $subject
        Body = $body
        BodyAsHtml = $true
    }
    Send-MailMessage @mailParams -ErrorAction Stop
    Write-Output "Email sent successfully to $($recipients -join ', ') at $(Get-Date)"
}
catch {
    Write-Output "Error at $(Get-Date): $($_.Exception.Message)"
    Stop-Transcript
    exit 1
}
finally {
    Stop-Transcript
}
