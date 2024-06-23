{
  containerDefinitions: [
    {
      cpu: 0,
      essential: true,
      logConfiguration: {
        logDriver: 'awslogs',
        options: {
          'awslogs-group': 'test-logs',
          'awslogs-region': 'ap-northeast-1',
          'awslogs-stream-prefix': 'app',
        },
      },
      image: '{{ must_env `IMAGE_REGISTRY` }}:{{ must_env `IMAGE_TAG` }}',
      name: 'app',
      portMappings: [
        {
          containerPort: 3400,
          hostPort: 3400,
          protocol: 'tcp',
        },
      ],
      ulimits: [
        {
          hardLimit: 65536,
          name: 'nofile',
          softLimit: 65536,
        },
      ],
    },
  ],
  cpu: '{{ must_env `TASK_CPU_SIZE` }}',
  executionRoleArn: '{{ ssm `/ecspresso/application/task-exec-role-arn` }}',
  family: 'app',
  memory: '{{ must_env `TASK_MEM_SIZE` }}',
  networkMode: 'awsvpc',
  runtimePlatform: {
    cpuArchitecture: 'ARM64',
    operatingSystemFamily: 'LINUX',
  },
  requiresCompatibilities: [
    'FARGATE',
  ],
  taskRoleArn: '{{ ssm `/ecspresso/service/app/task-role-arn` }}',
}
