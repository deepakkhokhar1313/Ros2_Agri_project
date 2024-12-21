from setuptools import find_packages, setup

package_name = 'arm_control'

setup(
    name=package_name,
    version='0.0.0',
    packages=find_packages(exclude=['test']),
    data_files=[
        ('share/ament_index/resource_index/packages',
            ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='deepak',
    maintainer_email='deepakkhokhar1313@gmail.com',
    description='Ros2 Package for Arm Controller',
    license='Apache 2.0',
    tests_require=['pytest'],
    entry_points={
        'console_scripts': [
            'arm_controller_node = arm_control.arm_controller:main',
            'arm_rl_training_node = arm_control.arm_rl_training:main',
            'arm_action_server_node = arm_control.arm_action_server:main',
        ],
    },
)
