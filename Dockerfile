# Use an official ROS 2 image as a base for Jazzy, which is based on the latest Ubuntu
FROM ros:jazzy

# Set the working directory inside the container to match the project structure
WORKDIR /root/ros2_agri_project

# Copy essential files and directories from the host machine into the container's working directory
COPY requirements.txt ./
COPY src ./src
COPY config ./config
COPY data ./data
# COPY urdfmodel ./urdf

# Update the package list and install necessary system-level dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip \
    python3-dev \
    ros-$ROS_DISTRO-navigation2 \
    ros-$ROS_DISTRO-perception-pcl \
    ros-$ROS_DISTRO-moveit \
    ros-$ROS_DISTRO-ros-gz \
    ros-$ROS_DISTRO-xacro \
    wget bzip2

# Install Anaconda
RUN wget https://repo.anaconda.com/archive/Anaconda3-2023.09-0-Linux-x86_64.sh -O Anaconda3.sh && \
    bash Anaconda3.sh -b -p /opt/anaconda3 && \
    rm Anaconda3.sh

# Add Anaconda to PATH
ENV PATH="/opt/anaconda3/bin:$PATH"

# Create a conda environment
RUN conda create -n ros_env python=3.13 -y

# Activate the conda environment and install Python dependencies from requirements.txt
RUN /opt/anaconda3/envs/ros_env/bin/pip install -r requirements.txt

# Create a directory for the ROS2 workspace in the container
RUN mkdir -p /root/ros2_ws/src

# Copy the source code into the ROS2 workspace
RUN cp -r src /root/ros2_ws/src
RUN cp -r config /root/ros2_ws/config
RUN cp -r data /root/ros2_ws/data

# Add the ROS2 setup script and conda activation to .bashrc
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /root/.bashrc
RUN echo "source /root/ros2_ws/install/setup.bash" >> /root/.bashrc
RUN echo "conda activate ros_env" >> /root/.bashrc

# Switch the working directory to the ROS2 workspace
WORKDIR /root/ros2_ws

# Build the ROS2 project using 'colcon' and use symlink-install to use the source directories
RUN colcon build --symlink-install

# Set the command to run when the container starts
CMD ["bash"]