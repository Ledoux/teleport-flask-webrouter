#!/usr/bin/env bash

function deploy {
    GRID=$1
    PROJECT=$[backend.SITE_NAME]
    SERVER=$[server.name]

    export KEY_PATH=/home/shared/prod_keys/id_snips_apps
    COMMIT=`git log -1 --format="%h"`
    git archive -o git-archive.tar.gz --prefix $PROJECT-$COMMIT/ HEAD .

    machines=$(sky dns domain-names | \
        grep gce.snips.net | \
        sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" | \
        grep $PROJECT | \
        grep $GRID | \
        grep front | \
        sed 's/ .*//'
    )

    for machine in $machines
    do
        # copy zip
        scp -o StrictHostKeyChecking=no -i ${KEY_PATH} git-archive.tar.gz apps@$machine:git-archive.tar.gz

        # keep only 5 deploys
        ssh -o StrictHostKeyChecking=no -i ${KEY_PATH} apps@$machine "ls -dt $PROJECT-* | tail -n +5 | xargs rm -rf"

        # Unzip zip
        ssh -o StrictHostKeyChecking=no -i ${KEY_PATH} apps@$machine "tar zxf git-archive.tar.gz"

        # Install
        ssh -o StrictHostKeyChecking=no -i ${KEY_PATH} apps@$machine "cd $PROJECT-$COMMIT && cd backend/servers/$SERVER && sh scripts/install.sh"
    done

    for machine in $machines
    do
        # switch
        # http://blog.moertel.com/posts/2005-08-22-how-to-change-symlinks-atomically.html
        ssh -o StrictHostKeyChecking=no -i ${KEY_PATH} apps@$machine "ln -s $PROJECT-$COMMIT $PROJECT-tmp && mv -Tf $PROJECT-tmp $PROJECT"

        # Restart service
        ssh -o StrictHostKeyChecking=no -i ${KEY_PATH} apps@$machine "sudo service snips-$PROJECT restart"

        # Wait a bit
        sleep 5

        # Fail fast is service is not answering
        ssh -o StrictHostKeyChecking=no -i ${KEY_PATH} apps@$machine "curl -s http://localhost:5000/api/ping || (sudo cat /var/log/upstart/snips-$PROJECT.log | tail -250 ; false)"

        # Grant the load balancer some recovery time
        sleep 5
    done
}

set -e
set -x

GRID=$1

if [ "$GRID" = "dev" -o "$GRID" = "prod" ]
then
    echo "deploying to $GRID"
    deploy $GRID
    git tag -f deployed-$GRID
    git push -f origin deployed-$GRID
fi
