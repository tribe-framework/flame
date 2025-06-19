$FILE = ".flame"

# Prompt for input
$USER_INPUT = Read-Host "Please enter the name of the Ember directory"

$DIRECTORY = "applications\$USER_INPUT"

# Check if the .flame file exists
if (Test-Path $FILE) {
    # Check if the directory already exists
    if (-Not (Test-Path $DIRECTORY)) {
        # Create directory and navigate into it
        New-Item -ItemType Directory -Path $DIRECTORY -Force | Out-Null
        Set-Location $DIRECTORY

        # Initialize Ember app
        ember init

        # Automatically confirm installation prompts
        echo "y" | ember install ember-tribe
    } else {
        Write-Host "A directory already exists at $DIRECTORY. You cannot overwrite existing application."
    }
} else {
    Write-Host "This is not a Flame folder."
}
