#!/usr/bin/env bash

# Install Postgresql server on Centos7
install_pgsql () {
  echo "Install and start pgsql server"
  cd $HOME
  sudo yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
  sudo yum install postgresql12 postgresql12-contrib postgresql12-server -y
  sudo /usr/pgsql-12/bin/postgresql-12-setup initdb
  sudo systemctl enable postgresql-12 
  sudo systemctl start postgresql-12
  echo "Finished"
}

# Create pgsql Database table and copy data to the table using postgres user
create_table () {
  echo "Create pgsql table and copy data to the table"
  cd $HOME
  # git clone the csv data to local
  sudo git clone https://github.com/amohan14/PostgreSQL.git
  # Moving the csv data file to /tmp folder as all users(including postgres user) can access /tmp folder
  sudo mv /home/centos/PostgreSQL/persons.csv /tmp
  # Changing owner and access rights to the .csv file
  sudo chown postgres /tmp/persons.csv
  sudo chmod 755 /tmp/persons.csv
  sudo cd ~postgres
  # sudo -u postgres -i
  sudo su - postgres
  # Creating table and copying csv data to the table
  psql -c "create table persons (id serial, first_name varchar(50), last_name varchar(50),dob date, email varchar(255), primary key (id) );"
  psql -c "COPY persons(first_name, last_name, dob, email) FROM '/tmp/persons.csv' DELIMITER ',' CSV HEADER;"
  echo "Finished"
}

# Runs the functions
echo "Setting up pgsql server and creating and copying csv data to pgsql table"
install_pgsql
create_table
echo "Script Finished"
