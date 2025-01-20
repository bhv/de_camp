import os

if __name__ == '__main__':
    name = os.getenv('USER_NAME','sagar')
    print(f'Hello {name} from docker!')