FILE=.flame
DIRECTORY=applications/home
if test -f "$FILE"; then
    if [ ! -d "$DIRECTORY" ]; then
        mkdir $DIRECTORY;
        cd $DIRECTORY;
        ember init;
        yes | ember install ember-tribe;
        php sync-types.php;
        ember build -prod;
        cd ../../;
        rm build.sh;
    else
        echo "A directory already exists at applications/home. You cannot overwrite existing application."
    fi
else
    echo "This is not a Flame folder."
fi