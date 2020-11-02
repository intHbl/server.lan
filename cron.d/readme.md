

## backup
entry: backup.sh 
->
  (serviceName){ 
    ->backup.borg.sh  $serviceName
    ---> backup.remote.sh $serviceName &
  }


## recover
TODO
```shell
check dir is not exists || is empty
then
    stop service if running
    borg  borg_repo  -- > data 
    start service
fi
```

