import sys
import os

# Add the app directory to the system path
sys.path.append(r"c:\Users\parth\OneDrive\Desktop\EDI_SEM4\SafeHer-Backend\SafeHer-Backend-main\SafeHer-Backend-main\app")

from services.ai_service import AIService

print("Testing AI generation...")
try:
    res = AIService.generate_reply(
        message="hello",
        user_id="gZjd2nm5MKPF20xJll9srBfoVao1",
        lat=18.5204,
        lng=73.8567
    )
    print("Success! Reply:")
    print(res)
except Exception as e:
    print("Failed with error:")
    print(e)
