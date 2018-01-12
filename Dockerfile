# Specify the image that this app is going to be built from.  This is a docker hub hosted Node image
	FROM node:8

# Specify the username this app is going to run in
	ENV USER=app

# Specify the subdirectory (/home/user/sub_dir_here) that this app will run in
	ENV SUBDIR=appDir

# Create a user named $USER.  Run npm install as root before doing other commands
	RUN useradd --user-group --create-home --shell /bin/false $USER &&\
		npm install --global tsc-watch npm ntypescript typescript gulp-cli concurrently

# The default directory created for a user in node is /home/user_name
	ENV HOME=/home/$USER

# Copy package.json and the gulpfile as root into the subdir where our app lies
	COPY package.json gulpfile.js tsconfig.json $HOME/$SUBDIR/

# set the $USER as the owner of the $HOME directory.  Necessary after copying the files from the line above
	RUN chown -R $USER:$USER $HOME/*

# Change user to $USER
	USER $USER

# Change directory to the specified subdirectory
	WORKDIR $HOME/$SUBDIR

# As this user, finally run NPM install
	RUN npm install

## These lines are not necessary because we're creating a volume from the docker-compose.yml file.
## If we were to not use a volume there, these would be necessary

# Change the user to root to finalize some commands
#	USER root

# Copy our working directory from the host machine (your machine) into the Docker container
# Not necessary since gulp is taking care of this for us
#   COPY . $HOME/$SUBDIR

# Copying has copied as the root user, so set the owner once again to our specified username
#	RUN chown -R $USER:$USER $HOME/**/*

# Finally, switch back to the non root user and run the final command
#	USER $USER

# Kick node off from the compiled dist folder, which is compiled from our simple gulpfile
	CMD ["node", "dist/index.js"]
