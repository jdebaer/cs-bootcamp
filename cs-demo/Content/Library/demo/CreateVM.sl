namespace: demo
flow:
  name: CreateVM
  inputs:
    - host: 10.0.46.10
    - username: "Capa1\\1301-capa1user"
    - password: Automation123
    - datancenter: Capa1 Datacenter
    - image: Ubuntu
    - folder: Students/jdebaer
    - prefix_list: '1-,2-,3-'
  workflow:
    - uuid:
        do:
          io.cloudslang.demo.uuid: []
        publish:
          - uuid: '${"jdebaer-" + uuid}'
        navigate:
          - SUCCESS: substring
    - substring:
        do:
          io.cloudslang.base.strings.substring:
            - origin_string: '${uuid}'
            - end_index: '16'
        publish:
          - id: '${new_string}'
        navigate:
          - SUCCESS: clone_vm
          - FAILURE: on_failure
    - clone_vm:
        do:
          io.cloudslang.vmware.vcenter.vm.clone_vm:
            - host: '${host}'
            - user: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - vm_source_identifier: name
            - vm_source: '${image}'
            - datacenter: '${datancenter}'
            - vm_name: '${id}'
            - vm_folder: '${folder}'
            - mark_as_template: 'false'
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      uuid:
        x: 67
        y: 139
      substring:
        x: 240
        y: 73
      clone_vm:
        x: 417
        y: 97
        navigate:
          e0220926-b916-5c31-a2a8-a6f8ad87ce38:
            targetId: 29f57b8d-d3ac-38c5-ca16-0d1e433ed2fd
            port: SUCCESS
    results:
      SUCCESS:
        29f57b8d-d3ac-38c5-ca16-0d1e433ed2fd:
          x: 627
          y: 121
