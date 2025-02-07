FILE=.flame

echo "Please enter the name of the Ember directory:"
read USER_INPUT

DIRECTORY="applications/$USER_INPUT"

if test -f "$FILE"; then
    if [ ! -d "$DIRECTORY" ]; then
        mkdir -p "$DIRECTORY";  # Use -p to create parent directories if needed
        cd "$DIRECTORY" || exit; # Change to the directory, exit if it fails
        ember init;
        yes | ember install ember-tribe;
    else
        echo "A directory already exists at $DIRECTORY. You cannot overwrite existing application."
    fi
else
    echo "This is not a Flame folder."
fi
